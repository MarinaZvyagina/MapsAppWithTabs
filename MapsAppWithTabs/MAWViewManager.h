//
//  MAVViewManager.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 12.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAWATMList;
@protocol MAWViewManager <NSObject>
-(void)updateViewWithATMs:(MAWATMList *)atms;
@end
