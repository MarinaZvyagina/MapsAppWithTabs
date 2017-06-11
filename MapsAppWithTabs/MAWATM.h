//
//  MAVATM.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface MAWATM : NSObject

@property (nonatomic,strong) NSString *atmId;
@property (nonatomic,strong) NSString *placeId;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *name;
@property (nonatomic) CLLocationCoordinate2D coordinate;


@end
