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
#import <MapKit/MapKit.h>


@interface MAWTMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) id<MAWMapDataManager> dataManager;
@property (nonatomic, strong) MAWATMList * atms;
@property (nonatomic, strong) UIButton * buttonPlus;
@property (nonatomic, strong) UIButton * buttonMinus;
@property (nonatomic, strong) UIButton * buttonNavigationTriangle;
@property (nonatomic, strong) UIButton * buttonPath;
@property (nonatomic, strong) MKDirections *routes;
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@end

@implementation MAWTMapViewController
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
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds ];
    _atms = [MAWATMList new];
    _myLocationManager = [CLLocationManager new];
    
    _mapView.delegate = self;
    _myLocationManager.delegate = self;

    if ([_myLocationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        [_myLocationManager requestWhenInUseAuthorization];
    }
    [_myLocationManager startUpdatingLocation];
    
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.showsScale = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.scrollEnabled = "YES";
    self.mapView.zoomEnabled = "YES";
    [self.view addSubview:self.mapView];
    
    [self setPlusAndMinusButtons];
    [self setNavigationTriangleButton];
    [self setPathButton];
    
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.coordinate;
    [self.dataManager getATMsWithCoordinates:&coordinate AndViewManager:self];
    self.mapView.mapType = MKMapTypeStandard;
}

-(void)setNavigationTriangleButton {
    self.buttonNavigationTriangle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-40, self.view.bounds.size.height - 100, 30, 30)];
    [self setImageForButton:self.buttonNavigationTriangle withName:@"65346" andType:@"png"];
    [self.buttonNavigationTriangle addTarget:self action:@selector(buttonNavigationPushed) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonNavigationTriangle.backgroundColor = UIColor.whiteColor;
    self.buttonNavigationTriangle.alpha = 0.7;
    
    [self.view addSubview:self.buttonNavigationTriangle];
}

-(void)setPlusAndMinusButtons {
    self.buttonPlus = [[UIButton alloc] initWithFrame:CGRectMake(5, 200, 30, 50)];
    self.buttonMinus = [[UIButton alloc] initWithFrame:CGRectMake(5, 250, 30, 50)];

    self.buttonPlus.backgroundColor = [UIColor whiteColor];
    self.buttonMinus.backgroundColor = [UIColor whiteColor];

    self.buttonPlus.alpha = 0.6;
    self.buttonMinus.alpha = 0.6;

    [self.buttonPlus setTitle:@"+" forState:UIControlStateNormal];
    [self.buttonPlus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonMinus setTitle:@"-" forState:UIControlStateNormal];
    [self.buttonMinus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.buttonPlus addTarget:self action:@selector(buttonPlusPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonMinus addTarget:self action:@selector(buttonMinusPushed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.buttonPlus];
    [self.view addSubview:self.buttonMinus];

}

-(void)setPathButton {
    self.buttonPath = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-40, self.view.bounds.size.height - 140, 30, 30)];
    [self setImageForButton:self.buttonPath withName:@"route" andType:@"png"];
    self.buttonPath.alpha = 0.6;
    [self.buttonPath addTarget:self action:@selector(buttonPathPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPath];
}

-(void)setImageForButton:(UIButton *)button withName:(NSString *)name andType:(NSString *)type {
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage *imageObject = [UIImage imageWithContentsOfFile:imageFilePath];
    [button setImage:imageObject forState:UIControlStateNormal];
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

#pragma mark - work with annotations

-(NSArray<MKPointAnnotation *> *)getSelectedAnnotations {
    NSArray<MKPointAnnotation *> * array = self.mapView.selectedAnnotations;
    return array;
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

#pragma mark - buttons handlers

-(void)buttonNavigationPushed {
    [self setRegionForCoordinate:self.mapView.userLocation.coordinate];
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

-(void)buttonPathPushed {
    NSArray<MKPointAnnotation *> * annotations = [self getSelectedAnnotations];
    for (MKPointAnnotation *annotation in annotations) {
        [self showPathTo:annotation.coordinate];
    }
}

- (void)showPathTo: (CLLocationCoordinate2D) toCoordinate {
    if ([self.routes isCalculating]) {
        [self.routes cancel];
    }
    CLLocationCoordinate2D coordinate = toCoordinate;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    directionsRequest.source = source;
    directionsRequest.destination = destination;
    directionsRequest.requestsAlternateRoutes = YES;
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    self.routes = [[MKDirections alloc] initWithRequest:directionsRequest];
    [self.routes calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                            message:@"Some error with path... try again later"
                                                           delegate:nil
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self.mapView removeOverlays:self.mapView.overlays];
            NSMutableArray* routes = [NSMutableArray new];
            for (MKRoute* route in response.routes){
                [routes addObject:route.polyline];
            }
            [self.mapView addOverlays:routes level:MKOverlayLevelAboveRoads];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

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

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [[UIColor alloc] initWithRed:92/255.0 green:0xDF/255.0 blue:54/255.0 alpha:0.7];
    renderer.lineWidth = 4.0;
    return renderer;
}

@end
