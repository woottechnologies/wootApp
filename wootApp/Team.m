//
//  Team.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Team.h"

@interface Team()

@property (nonatomic, assign) NSInteger wins;
@property (nonatomic, assign) NSInteger losses;

@end

@implementation Team

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.teamID = [dictionary[TeamIDKey] integerValue];
        self.schoolID = [dictionary[SchoolIDKey] integerValue];
        self.type = dictionary[TypeKey];
        self.wins = [dictionary[WinsKey] integerValue];
        self.losses = [dictionary[LossesKey] integerValue];
        self.record = [self record];
    }
    
    return self;
}

- (NSString *)record {
    return [NSString stringWithFormat:@"%li - %li", self.wins, self.losses];
}

@end
