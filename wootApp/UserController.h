//
//  UserController.h
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "TeamController.h"
#import "UserProfileViewController.h"

static NSString *UserKey = @"user";
static NSString *FollowingKey = @"following";
static NSString *FollowingIDKey = @"id";
static NSString *FollowingNameKey = @"name";
static NSString *FollowingTypeKey = @"type";

@interface UserController : NSObject

@property (nonatomic, strong) User *currentUser;

+ (instancetype)sharedInstance;
- (void)registerInDBWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)logInUserWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)followAccount:(id)account;
- (void)unfollowAccount:(id)account;

@end
