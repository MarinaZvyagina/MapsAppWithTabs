//
//  MAWTMapViewController.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "MAWTMapViewController.h"
#import "MAWMapDataManager.h"
#import "MAWATMList.h"
#import "MAWATM.h"


@interface MAWTMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) id<MAWMapDataManager> dataManager;
@property (nonatomic, strong) MAWATMList * atms;
@property (nonatomic, strong) UIButton * buttonPlus;
@property (nonatomic, strong) UIButton * buttonMinus;
@property (nonatomic, strong) UIButton * buttonNavigationTriangle;
@end

@implementation MAWTMapViewController

CLLocationManager *myLocationManager;
double delta = 0.05;

-(instancetype)initWithDataManager:(id<MAWMapDataManager>) dataManager {
    self = [super init];
    if (self) {
        self.dataManager = dataManager;
    }
    return self;
}

-(MAWATMList *)getCurrentAtms {
    return self.atms;
}

-(void)updateViewWithATMs:(MAWATMList *)atms {
    self.atms = atms;
    [self showAllAtms];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.atms = [MAWATMList new];
    myLocationManager = [[CLLocationManager alloc] init];

    if ([myLocationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        [myLocationManager requestWhenInUseAuthorization];
    }
    myLocationManager.delegate = self;
    [myLocationManager startUpdatingLocation];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds ];
    
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.showsUserLocation = YES; //show the user's location on the map, requires CoreLocation
    self.mapView.scrollEnabled = "YES";//the default anyway
    self.mapView.zoomEnabled = "YES";//the default anyway
    [self.view addSubview:self.mapView];
    
    
    self.buttonPlus = [[UIButton alloc] initWithFrame:CGRectMake(5, 200, 30, 50)];
    self.buttonMinus = [[UIButton alloc] initWithFrame:CGRectMake(5, 250, 30, 50)];
    self.buttonNavigationTriangle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-40, self.view.bounds.size.height - 100, 30, 30)];
    self.buttonPlus.backgroundColor = [UIColor whiteColor];
    self.buttonMinus.backgroundColor = [UIColor whiteColor];
    self.buttonNavigationTriangle.backgroundColor = [UIColor whiteColor];
    self.buttonPlus.alpha = 0.6;
    self.buttonMinus.alpha = 0.6;
    self.buttonNavigationTriangle.alpha = 0.7;
    [self.buttonPlus setTitle:@"+" forState:UIControlStateNormal];
    [self.buttonPlus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonMinus setTitle:@"-" forState:UIControlStateNormal];
    [self.buttonMinus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"65346" ofType:@"png"];
    UIImage *imageObject = [UIImage imageWithContentsOfFile:imageFilePath];
    [self.buttonNavigationTriangle setImage:imageObject forState:UIControlStateNormal];

    
    
    [self.buttonPlus addTarget:self action:@selector(buttonPlusPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonMinus addTarget:self action:@selector(buttonMinusPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonNavigationTriangle addTarget:self action:@selector(buttonNavigationPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPlus];
    [self.view addSubview:self.buttonMinus];
    [self.view addSubview:self.buttonNavigationTriangle];
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.coordinate;
    [self.dataManager getATMsWithCoordinates:&coordinate AndViewManager:self];
    self.mapView.mapType = MKMapTypeStandard;
}

-(void)buttonPlusPushed {
    delta -= delta/5;
    if (delta < 0.000001) {
        delta = 0.000001;
    }
    [self setRegionForCoordinate:self.mapView.userLocation.coordinate];
}

-(void)buttonMinusPushed {
    delta += delta/5;
    if (delta > 150.0) {
        delta = 150.0;
    }
    [self setRegionForCoordinate:self.mapView.userLocation.coordinate];
}


-(void)buttonNavigationPushed {
    CLLocationCoordinate2D location = self.mapView.userLocation.coordinate;
    [self.dataManager getATMsWithCoordinates:&location AndViewManager:self];
    [self setRegionForCoordinate:self.mapView.userLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationDegrees latitudeDelta = fabs(newLocation.coordinate.latitude - oldLocation.coordinate.latitude);
    CLLocationDegrees longitudeDelta = fabs(newLocation.coordinate.longitude - oldLocation.coordinate.longitude);
    if ((latitudeDelta < 0.00001) && (longitudeDelta < 0.00001) ) {
        return;
    }
    CLLocationCoordinate2D location = newLocation.coordinate;
    [self setRegionForCoordinate:location];
    [self.dataManager getATMsWithCoordinates:&location AndViewManager:self];
}

-(void)setRegionForCoordinate:(CLLocationCoordinate2D) location {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = delta;
    span.longitudeDelta = delta;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

-(void)showAllAtms {
    for (MAWATM *atm in self.atms.atms) {
        NSString * coordinate = atm.coordinate;
        NSArray* myArray = [coordinate  componentsSeparatedByString:@","];
        NSString* firstString = myArray[0];
        NSString* secondString = myArray[1];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([firstString doubleValue], [secondString doubleValue]);
        
        [self setAnnotationWithCoordinate:&coord Name:atm.name AndAddress:atm.address];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setAnnotationWithCoordinate:(CLLocationCoordinate2D*)coordinate Name:(NSString *)name AndAddress:(NSString *)address{
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = coordinate->latitude;
    annotationCoord.longitude = coordinate->longitude;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = name;
    annotationPoint.subtitle = address;
    [self.mapView addAnnotation:annotationPoint];

}


@end
