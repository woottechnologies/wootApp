//
//  Athlete.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Athlete.h"

@implementation Athlete

- (instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.athleteID = [dictionary[AthleteIDKey] integerValue];
        self.name = dictionary[NameKey];
        self.jerseyNumber = [dictionary[JerseyNumberKey] integerValue];
        self.photo = dictionary[PhotoKey];
        self.position = dictionary[PositionKey];
        self.height = [dictionary[HeightKey] integerValue];
        self.weight = [dictionary[WeightKey] integerValue];
        self.year = [dictionary[YearKey] integerValue];
        self.isCaptain = dictionary[IsCaptainKey];
        self.isStarter = dictionary[IsStarterKey];
        self.views = [dictionary[ViewsKey] integerValue];
        
        NSDictionary *athleteDictionary = @{AthleteIDKey:@3,
                                            NameKey:@"John Smith",
                                            JerseyNumberKey:@12,
                                            PhotoKey:@"john_smith",
                                            PositionKey:@"LB",
                                            HeightKey:@72,
                                            WeightKey:@168,
                                            YearKey:@12,
                                            IsCaptainKey:@0,
                                            IsStarterKey:@1,
                                            ViewsKey:@239};
        
    }
    return self;
}

@end
