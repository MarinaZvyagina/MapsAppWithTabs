//
//  MAWMapDataManager.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 18.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol MAWViewManager;

@protocol MAWMapDataManager <NSObject>

@required
-(void)getATMsWithCoordinates:(CLLocationCoordinate2D *)coordinate AndViewManager:(id<MAWViewManager>) viewManager;

@end
