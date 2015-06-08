//
//  School.h
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSString *SchoolIDKey = @"id";
static NSString *NameKey = @"name";
static NSString *AddressKey = @"street";
static NSString *CityKey = @"city";
static NSString *StateKey = @"state";
static NSString *ZipKey = @"zip";
static NSString *RegionKey = @"region";
static NSString *DivisionKey = @"division";
static NSString *MascottKey = @"mascott";
static NSString *LogoKey = @"logo";
static NSString *PrimaryColorKey = @"primaryColor";
static NSString *SecondaryColorKey = @"secondaryColor";

@interface School : NSObject

@property (nonatomic, assign) NSInteger schoolID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *division;
@property (nonatomic, strong) NSString *mascott;
@property (nonatomic, strong) UIImage *logo;
@property (nonatomic, strong) NSString *primaryColor;
@property (nonatomic, strong) NSString *secondaryColor;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
