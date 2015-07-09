//
//  Athlete.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Athlete.h"

@implementation Athlete

- (instancetype)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.athleteID = [dictionary[AthleteIDKey] integerValue];
        self.name = dictionary[AthleteNameKey];
        
        self.position = dictionary[PositionKey];
        
        if (dictionary[JerseyNumberKey] != (id)[NSNull null]) {
            self.jerseyNumber = [dictionary[JerseyNumberKey] integerValue];
        }
        
        if (dictionary[StatTypeKey] != (id)[NSNull null]) {
            self.statType = [dictionary[StatTypeKey] integerValue];
        }
        
        if (dictionary[HeightKey] != (id)[NSNull null]) {
            self.height = [dictionary[HeightKey] integerValue];
        }
        
        if (dictionary[WeightKey] != (id)[NSNull null]) {
            self.weight = [dictionary[WeightKey] integerValue];
        }
        
        if (dictionary[YearKey] != (id)[NSNull null]) {
            self.year = [dictionary[YearKey] integerValue];
        }
        
        if (dictionary[BioKey] != (id)[NSNull null]) {
            self.bio = [NSString stringWithFormat:@"%@", dictionary[BioKey]];
        }
        
        if (dictionary[ViewsKey] != (id)[NSNull null]) {
            self.views = [dictionary[ViewsKey] integerValue];
        }
        
        if ([dictionary[IsCaptainKey] isEqualToString:@"Y"]) {
            self.isCaptain = YES;
        } else {
            self.isCaptain = NO;
        }
        if ([dictionary[IsStarterKey] isEqualToString:@"Y"]) {
            self.isStarter = YES;
        } else {
            self.isStarter = NO;
        }
        
        if (dictionary[SchoolIDKey] != (id)[NSNull null]) {
            self.schoolID = [dictionary[SchoolIDKey] integerValue];
        }
    }
    return self;
}

@end
