//
//  MAVGooglePlacesData.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 08.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "MAWViewManager.h"

@interface MAWGooglePlacesData : NSObject
-(void)getATMsWithCoordinates:(CLLocationCoordinate2D *)coordinate AndViewManager:(id<MAWViewManager>) viewManager;
@end
