//
//  UserController.h
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserController : NSObject

@property (nonatomic, strong) User *currentUser;

+ (instancetype)sharedInstance;
- (void)registerInDBWithCompletion:(void (^)(BOOL success, NSString *error))completion;
- (void)logInUserWithCompletion:(void (^)(BOOL success, NSString *error))completion;

@end
