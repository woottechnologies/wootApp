//
//  User.m
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.userID = [dictionary[UserIDKey] integerValue];
        self.email = dictionary[EmailKey];
    }
    
    return self;
}

@end
