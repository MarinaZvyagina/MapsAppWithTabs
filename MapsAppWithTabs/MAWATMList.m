//
//  MAWATMList.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "MAWATMList.h"

@interface MAWATMList ()
@property(nonatomic, copy, readwrite) NSArray *atms;
@end

@implementation MAWATMList

- (instancetype)initWithArray:(NSArray<MAWATM *> *)atms {
    self = [super init];
    if (self) {
        _atms = atms;
    }
    return self;
}

- (NSUInteger)count {
    return self.atms.count;
}

- (MAWATM*)objectAtIndexedSubscript:(NSUInteger)index {
    return self.atms[index];
}

@end
