//
//  School.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "School.h"

@implementation School

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.schoolID = [dictionary[SchoolIDKey] integerValue];
        self.name = dictionary[NameKey];
        self.address = dictionary[AddressKey];
        self.city = dictionary[CityKey];
        self.state = dictionary[StateKey];
        self.zip = dictionary[ZipKey];
        self.region = dictionary[RegionKey];
        self.division = dictionary[DivisionKey];
        self.mascott = dictionary[MascottKey];
        self.primaryColor = dictionary[PrimaryColorKey];
        self.secondaryColor = dictionary[SecondaryColorKey];
    }
    
    return self;
}

@end
