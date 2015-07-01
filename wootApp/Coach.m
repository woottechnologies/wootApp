//
//  Coach.m
//  wootApp
//
//  Created by Cole Wilkes on 6/29/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Coach.h"

@implementation Coach

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.coachID = [dictionary[CoachIDKey] integerValue];
        self.name = dictionary[CoachNameKey];
        self.title = dictionary[TitleKey];
    }
    
    return self;
}

@end
