//
//  School.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "School.h"
#import "UIColor+CreateMethods.h"
@import UIKit;

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
        self.primaryColor = [UIColor colorWithHex:dictionary[PrimaryColorKey] alpha:1];
<<<<<<< HEAD
     //   self.secondaryColor = [UIColor colorWithHex:dictionary[SecondaryColorKey] alpha:1];
=======
        //self.secondaryColor = [UIColor colorWithHex:dictionary[SecondaryColorKey] alpha:1];
>>>>>>> 7b0de26a22190d972074a9d7f17a28d6d151cea7
    }
    
    return self;
}

@end
