//
//  Person.m
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Person.h"
#import "SchoolController.h"

@implementation Person

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.personID = [dictionary[PersonIDKey] integerValue];
        self.username = dictionary[PersonUserName];
        if (dictionary[PersonNameKey]) {
            self.name = dictionary[PersonNameKey];
        }
        if (dictionary[PersonViewsKey] != (id)[NSNull null]) {
            self.views = [dictionary[PersonViewsKey] integerValue];
        }
    }
    return self;
}

@end
