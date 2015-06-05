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
        self.photo = [UIImage imageNamed:dictionary[PhotoKey]];
        self.position = dictionary[PositionKey];
        self.height = [dictionary[HeightKey] integerValue];
        self.weight = [dictionary[WeightKey] integerValue];
        self.year = [dictionary[YearKey] integerValue];
        self.bio = dictionary[BioKey];
        self.isCaptain = dictionary[IsCaptainKey];
        self.isStarter = dictionary[IsStarterKey];
        self.views = [dictionary[ViewsKey] integerValue];
    }
    return self;
}

@end
