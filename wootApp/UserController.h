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
static NSString *FollowingCountKey = @"followingCount";
static NSString *FollowingKey = @"following";
static NSString *FollowingIDKey = @"id";
static NSString *FollowingNameKey = @"name";
static NSString *FollowingTypeKey = @"type";
static NSString *FollowingTwitterKey = @"twitter";

@interface UserController : NSObject

@property (nonatomic, strong) User *currentUser;

+ (instancetype)sharedInstance;
- (void)registerInDBWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)logInUserWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)loadFollowingFromDBWithCompletion:(void (^)(BOOL success, NSArray *following))completion;
- (void)followAccount:(id)account withCompletion:(void (^)(BOOL success))completion;
- (void)unfollowAccount:(id)account withCompletion:(void (^)(BOOL success))completion;
- (void)saveUserLocal;
- (void)changeUsernameUsingString:(id)newUsername andCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)changeEmailUsingString:(id)newEmail andCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)confirmPasswordUsingString:(id)password andCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)changePasswordUsingString:(id)password andCompletion:(void (^)(BOOL success, NSString *error))completion;

@end
