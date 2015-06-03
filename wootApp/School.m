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
        self.schoolID = dictionary[SchoolIDKey];
        self.name = dictionary[NameKey];
        self.address = dictionary[AddressKey];
        self.region = dictionary[RegionKey];
        self.division = dictionary[DivisionKey];
        self.mascott = dictionary[MascottKey];
        self.logo = [UIImage imageNamed:dictionary[LogoKey]];
        self.primaryColor = dictionary[PrimaryColorKey];
        self.secondaryColor = dictionary[SecondaryColorKey];
    }
    
    return self;
}

@end
