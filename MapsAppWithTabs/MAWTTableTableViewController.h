//
//  MAWTTableTableViewController.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAWViewManager;

@interface MAWTTableTableViewController : UITableViewController
-(instancetype)initWithMapViewManager:(id<MAWViewManager>) manager;
@end
