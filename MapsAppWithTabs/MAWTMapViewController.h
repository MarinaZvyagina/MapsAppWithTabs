//
//  MAWTMapViewController.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAWViewManager.h"
@import MapKit;
@import CoreLocation;

@protocol MAWMapDataManager;

@interface MAWTMapViewController : UIViewController <MAWViewManager>
-(instancetype)initWithDataManager:(id<MAWMapDataManager>) dataManager;
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
@end
