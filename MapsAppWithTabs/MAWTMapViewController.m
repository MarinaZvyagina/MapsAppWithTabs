//
//  MAWTMapViewController.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "MAWTMapViewController.h"
#import "MAWMapDataManager.h"
#import "MAWViewManager.h"
#import "MAWATMList.h"
#import "MAWATM.h"


@interface MAWTMapViewController () <MKMapViewDelegate, MAWViewManager, CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) id<MAWMapDataManager> dataManager;
@property (nonatomic, strong) MAWATMList * atms;
@end

@implementation MAWTMapViewController

CLLocationManager *myLocationManager;

-(instancetype)initWithDataManager:(id<MAWMapDataManager>) dataManager {
    self = [super init];
    if (self) {
        self.dataManager = dataManager;
    }
    return self;
}

-(void)updateViewWithATMs:(MAWATMList *)atms {
    self.atms = atms;
    [self showAllAtms];
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
    
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.coordinate;
    [self.dataManager getATMsWithCoordinates:&coordinate AndViewManager:self];
    self.mapView.mapType = MKMapTypeStandard;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location=newLocation.coordinate;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
  //  CLLocationCoordinate2D location=newLocation.coordinate;
    
    NSLog(@"Location after calibration, user location (%f, %f)", _mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
    [self.dataManager getATMsWithCoordinates:&location AndViewManager:self];
}

-(void)showAllAtms {
    for (MAWATM *atm in self.atms.atms) {
        NSString * coordinate = atm.coordinate;
        NSArray* myArray = [coordinate  componentsSeparatedByString:@","];
        
        NSString* firstString = [myArray objectAtIndex:0];
        NSString* secondString = [myArray objectAtIndex:1];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([firstString doubleValue], [secondString doubleValue]);
        
        [self setAnnotationWithCoordinate:&coord Name:atm.name AndAddress:atm.address];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setAnnotationWithCoordinate:(CLLocationCoordinate2D*)coordinate Name:(NSString *)name AndAddress:(NSString *)address{
    CLLocationCoordinate2D annotationCoord;//[self addressLocation] ;
    
    annotationCoord.latitude = coordinate->latitude;
    annotationCoord.longitude = coordinate->longitude;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = name;
    annotationPoint.subtitle = address;
    [self.mapView addAnnotation:annotationPoint];

}


@end
