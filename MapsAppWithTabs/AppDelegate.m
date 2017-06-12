//
//  AppDelegate.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MAWGooglePlacesData.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    ViewController *tabBarController = [ViewController new];
    window.rootViewController = tabBarController;
    self.window = window;
    [window makeKeyAndVisible];
    return YES;
}



@end
