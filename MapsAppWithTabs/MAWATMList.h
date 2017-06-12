//
//  MAWATMList.h
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAWATM.h"

@interface MAWATMList : NSObject

- (instancetype)initWithArray:(NSArray<MAWATM *> *)atms;
- (MAWATM*)objectAtIndexedSubscript:(NSUInteger)index;
- (NSUInteger)count;
@property(nonatomic, copy, readwrite) NSArray *atms;
@end
