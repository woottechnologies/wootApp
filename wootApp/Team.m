//
//  Team.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Team.h"
#import "GameController.h"

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
        //self.scheduleID = [dictionary[ScheduleIDKey] integerValue];
    }
    
    return self;
}

- (NSString *)record {
    return [NSString stringWithFormat:@"%li - %li", self.wins, self.losses];
}

- (NSArray *)schedule {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"date"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [_schedule sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedEventArray;
}

@end
