//
//  User.h
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *UserIDKey = @"id";
static NSString *EmailKey = @"email";

@interface User : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *following;
@property (nonatomic, strong) NSArray *favorites;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
