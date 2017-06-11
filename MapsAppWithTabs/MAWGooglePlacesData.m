//
//  MAVGooglePlacesData.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 08.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "MAWGooglePlacesData.h"
#import "MAWATM.h"
#import "MAWATMList.h"
@import GooglePlaces;
@import GoogleMaps;

@implementation MAWGooglePlacesData

NSString * kAPIKey = @"AIzaSyAPEMpW1XZFEiBr3387C47FaPwR1D57rdk";

-(void)getATMsWithCoordinates:(CLLocationCoordinate2D *)coordinate AndViewManager:(id<MAWViewManager>) viewManager {
    
    
    NSString*url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&types=atm&key=%@",coordinate->latitude, coordinate->longitude ,kAPIKey];
    NSURLRequest *nsurlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionConfiguration * defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
     
    NSURLSessionTask * downloadTask = [session dataTaskWithRequest:nsurlRequest completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
        NSDictionary * JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [viewManager updateViewWithATMs:[self getAtmFromJson:JSONObject]];
    }];
     [downloadTask resume];
}

-(MAWATMList *)getAtmFromJson: (NSDictionary *) JSONObject {
    NSDictionary * ATMs = [JSONObject objectForKey:@"results"];
    MAWATM* (^createATM)(NSString *, NSString *, NSString *, CLLocationCoordinate2D, NSString *);
    createATM = ^MAWATM*(NSString *name,
                         NSString *atmId,
                         NSString *placeId,
                         CLLocationCoordinate2D coordinate,
                         NSString *address) {
        MAWATM *atm = [MAWATM new];
        atm.atmId = atmId;
        atm.placeId = placeId;
        atm.coordinate = coordinate;
        atm.address = address;
        atm.name = name;
        return atm;
    };
    
    NSMutableArray *resultAtms = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (NSDictionary *atm in ATMs) {
        NSString *name = atm[@"name"];
        NSString *atmId = atm[@"id"];
        NSString *placeId = atm[@"place_id"];
        NSDictionary *geometry = atm[@"geometry"];
        NSDictionary *location = geometry[@"location"];
        double latitude = [location[@"lat"] doubleValue];
        double longitude = [location[@"lng"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        NSString * address = atm[@"vicinity"];
        [resultAtms addObject:createATM(name,atmId,placeId,coordinate,address)];
    }
    
    MAWATMList * atmList = [[MAWATMList alloc] initWithArray:resultAtms];
    return atmList;
}

@end
