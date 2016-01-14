//
//  User.h
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSString *UserIDKey = @"id";
static NSString *EmailKey = @"email";
static NSString *UsernameKey = @"handle";
static NSString *PersonPhotoKey = @"photo";
static NSString *HeaderPhotoKey = @"headerPhoto";
static NSString *NameKey = @"name";

@interface User : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *following;
@property (nonatomic, strong) NSArray *favorites;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *headerPhoto;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (BOOL)isFollowing:(id)account;

@end
