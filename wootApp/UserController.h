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

static NSString *UserKey = @"user";
static NSString *FavoritesKey = @"favorites";
static NSString *FavIDKey = @"id";
static NSString *FavNameKey = @"name";
static NSString *FavTypeKey = @"type";

@interface UserController : NSObject

@property (nonatomic, strong) User *currentUser;

+ (instancetype)sharedInstance;
- (void)registerInDBWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)logInUserWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)addFavorite:(id)favorite;
- (void)removeFavorite:(id)favorite;

@end
