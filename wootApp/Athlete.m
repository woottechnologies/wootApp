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
        self.jerseyNumber = [dictionary[JerseyNumberKey] integerValue];
       // self.photo = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dictionary[PhotoKey]]];
        self.position = dictionary[PositionKey];
        self.statType = [dictionary[StatTypeKey] integerValue];
        self.height = [dictionary[HeightKey] integerValue];
        self.weight = [dictionary[WeightKey] integerValue];
        self.year = [dictionary[YearKey] integerValue];
        self.bio = [NSString stringWithFormat:@"%@", dictionary[BioKey]];
        self.views = [dictionary[ViewsKey] integerValue];
        
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
    }
    return self;
}

@end
