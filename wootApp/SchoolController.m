//
//  SchoolController.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SchoolController.h"
#import "School.h"

@implementation SchoolController

+(instancetype) sharedInstance{
    static SchoolController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SchoolController alloc]init];
    });
    
    return sharedInstance;
}

- (void)loadSchools{
    NSDictionary *wxHighSchoolDict = @{SchoolIDKey:@1,
                                       NameKey:@"Woods Cross",
                                       AddressKey:@"600 West 2200 South",
                                       CityKey:@"Woods Cross",
                                       StateKey:@"UT",
                                       RegionKey:@"6",
                                       DivisionKey:@"4A",
                                       LogoKey:@"wx_logo",
                                       PrimaryColorKey:@"blue",
                                       SecondaryColorKey:@"white"};
    
    NSMutableArray *schoolsMutable = [[NSMutableArray alloc] init];
    School *wxHighSchool = [[School alloc] initWithDictionary:wxHighSchoolDict];
    
    [schoolsMutable addObject:wxHighSchool];
    
    self.schools = schoolsMutable;
}


@end
