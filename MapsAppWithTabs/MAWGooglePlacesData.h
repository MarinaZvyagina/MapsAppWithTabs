//
//  MAVGooglePlacesData.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 08.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAWViewManager.h"
#import "MAWMapDataManager.h"
@import CoreLocation;

@interface MAWGooglePlacesData : NSObject <MAWMapDataManager>
-(void)getATMsWithCoordinates:(CLLocationCoordinate2D *)coordinate AndViewManager:(id<MAWViewManager>) viewManager;
@end
