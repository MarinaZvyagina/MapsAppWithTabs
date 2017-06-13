//
//  ViewController.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "ViewController.h"
#import "MAWTMapViewController.h"
#import "MAWTTableTableViewController.h"
#import "MAWGooglePlacesData.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MAWTMapViewController *controller1 = [[MAWTMapViewController alloc] initWithDataManager:[MAWGooglePlacesData new]];
    MAWTTableTableViewController *controller2 = [[MAWTTableTableViewController alloc] initWithMapViewManager:controller1];
    
    self.viewControllers = [NSArray arrayWithObjects:
                                        controller1,
                                        controller2,
                                        nil];
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"];
    UITabBarItem * item = controller1.tabBarItem;
    [self setImageWithPath:imageFilePath forItem:item];
    imageFilePath = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"png"];
    item = controller2.tabBarItem;
    [self setImageWithPath:imageFilePath forItem:item];
}

-(void)setImageWithPath:(NSString *)imageFilePath forItem:(UITabBarItem *)item {
    UIImage *imageObject = [UIImage imageWithContentsOfFile:imageFilePath];
    UIImage * compressedImage = [self imageWithImage:imageObject scaledToSize:CGSizeMake(30, 30)];
    [item setImage:compressedImage];
}

-(UIImage *)imageWithImage:(UIImage *)imageToCompress scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageToCompress drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
