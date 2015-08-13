//
//  UserController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UserController.h"
#import "NetworkController.h"
#import "SchoolController.h"


@implementation UserController

+ (instancetype)sharedInstance {
    static UserController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserController alloc] init];
        [sharedInstance loadUserLocal];
    });
    
    return sharedInstance;
}

#pragma mark - Create

- (void)registerInDBWithCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *email = self.currentUser.email;
    NSString *username = self.currentUser.username;
    NSString *password = self.currentUser.password;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&username=%@&passwd=%@", email, username, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"insert_user_new.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
            
            if (returnCode == 10) {
                NSInteger userID = [[responseDict objectForKey:@"id"] integerValue];
                self.currentUser.userID = userID;
                self.currentUser.password = nil;
                [self saveUserLocal];
                completion(YES, nil);
            } else if (returnCode == 20) {
                completion(NO, @"That email address is already in use.");
            } else if (returnCode == 40) {
                completion(NO, @"That username is already in use.");
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

#pragma mark - Read

- (void)logInUserWithCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *username = self.currentUser.username;
    NSString *password = self.currentUser.password;
    
    NSString *post = [NSString stringWithFormat:@"username=%@&passwd=%@", username, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_user_new.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
            dispatch_group_t followingGroup = dispatch_group_create();
            if (returnCode == 10) {
                NSInteger userID = [[responseDict objectForKey:@"id"] integerValue];
                NSString *handle = [responseDict objectForKey:@"handle"];
                NSString *email = [responseDict objectForKey:@"email"];
                self.currentUser.userID = userID;
                self.currentUser.username = handle;
                self.currentUser.password = nil;
                self.currentUser.email = email;
                dispatch_group_enter(followingGroup);
                [self loadFollowingFromDBWithCompletion:^(BOOL success, NSArray *following) {
                    if (success) {
                        self.currentUser.following = following;
                    }
                    dispatch_group_leave(followingGroup);
                }];
                dispatch_group_notify(followingGroup, dispatch_get_main_queue(), ^{
                    [self saveUserLocal];
                    completion(YES, nil);
                });
            } else if (returnCode == 20) {
                completion(NO, @"Incorrect username or password. Please try again.");
            } else {
                completion(NO, @"Username not found.");
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

- (void)loadFollowingFromDBWithCompletion:(void (^)(BOOL success, NSArray *following))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li", self.currentUser.userID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_follows.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutFollowing = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                    NSNumber *followingId = [NSNumber numberWithInteger:[[dict objectForKey:FollowingIDKey] integerValue]];
                    NSString *name = [dict objectForKey:FollowingNameKey];
                    NSString *type = [dict objectForKey:FollowingTypeKey];
                    NSString *twitter = [dict objectForKey:FollowingTwitterKey];
                    
                    NSDictionary *followingDict = @{FollowingIDKey:followingId, FollowingNameKey:name, FollowingTypeKey:type, FollowingTwitterKey:twitter};
                    [mutFollowing addObject:followingDict];
                }
                completion(YES, mutFollowing);
            } else {
                completion(YES, nil);
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

- (void)loadUserLocal {
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserKey];
    
    if (userDict == nil) {
        self.currentUser = nil;
    } else {
        self.currentUser = [[User alloc] initWithDictionary:userDict];
        
//        NSArray *followingLocal = [[NSUserDefaults standardUserDefaults] objectForKey:FollowingKey];
//        self.currentUser.following = followingLocal;
        
    }
}

#pragma mark - Update

- (void)saveUserLocal {
    NSDictionary *userDict = @{UserIDKey:[NSNumber numberWithInteger:self.currentUser.userID],
                               UsernameKey:self.currentUser.username,
                               EmailKey:self.currentUser.email};
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentUser.following.count forKey:FollowingCountKey];
    //[[NSUserDefaults standardUserDefaults] setObject:self.currentUser.following forKey:FollowingKey];
    //[[NSUserDefaults standardUserDefaults] setObject:self.currentUser.favorites forKey:FavoritesKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)followAccount:(id)account withCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableArray *tempFollowing = [[NSMutableArray alloc] initWithArray:self.currentUser.following];
    
    NSDictionary *newFollowDict;
    NSString *postString;
    
    if ([account isKindOfClass:[Team class]]) {
        Team *newFollow = account;
        
        newFollowDict = @{FollowingIDKey:[NSNumber numberWithInteger:newFollow.teamID],
                          FollowingNameKey:newFollow.teamName,
                          FollowingTypeKey:@"T",
                          FollowingTwitterKey:newFollow.twitter};
        
        postString = [NSString stringWithFormat:@"userID=%li&followID=%li&followType=T", (long)self.currentUser.userID, (long)newFollow.teamID];
    } else {
        Athlete *newFollow = account;
        
        newFollowDict = @{FollowingIDKey:[NSNumber numberWithInteger:newFollow.athleteID],
                          FollowingNameKey:newFollow.name,
                          FollowingTypeKey:@"A",
                          FollowingTwitterKey:newFollow.twitter};
        
        postString = [NSString stringWithFormat:@"userID=%li&followID=%li&followType=A", (long)self.currentUser.userID, (long)newFollow.athleteID];
    }
    
    [tempFollowing addObject:newFollowDict];
    
    // database
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"insert_follow.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
            
            if (returnCode == 10) {
                // success
                self.currentUser.following = [tempFollowing copy];
                [[NSUserDefaults standardUserDefaults] setInteger:self.currentUser.following.count forKey:FollowingCountKey];
//                [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.following forKey:FollowingKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (completion) {
                    completion(YES);
                }
            } else if (returnCode == 20) {
                // error
                
                if (completion) {
                    completion(NO);
                }
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
    
    [uploadTask resume];
}

- (void)unfollowAccount:(id)account withCompletion:(void (^)(BOOL success))completion  {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableArray *tempFollowing = [[NSMutableArray alloc] initWithArray:self.currentUser.following];
    
    NSDictionary *oldFollowDict;
    NSString *postString;
    
    if ([account isKindOfClass:[Team class]]) {
        Team *oldFollow = account;
        
        oldFollowDict = @{FollowingIDKey:[NSNumber numberWithInteger:oldFollow.teamID],
                            FollowingNameKey:oldFollow.teamName,
                            FollowingTypeKey:@"T",
                            FollowingTwitterKey:oldFollow.twitter};
        
        postString = [NSString stringWithFormat:@"userID=%li&followID=%li&followType=T", (long)self.currentUser.userID, (long)oldFollow.teamID];
    } else {
        Athlete *oldFollow = account;
        
        oldFollowDict = @{FollowingIDKey:[NSNumber numberWithInteger:oldFollow.athleteID],
                            FollowingNameKey:oldFollow.name,
                            FollowingTypeKey:@"A",
                            FollowingTwitterKey:oldFollow.twitter};
        
        postString = [NSString stringWithFormat:@"userID=%li&favoriteID=%li&favoriteType=A", (long)self.currentUser.userID, (long)oldFollow.athleteID];
    }
    
    [tempFollowing removeObject:oldFollowDict];
    
    // database
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"delete_follow.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
            
            if (returnCode == 10) {
                // success
                self.currentUser.following = [tempFollowing copy];
                [[NSUserDefaults standardUserDefaults] setInteger:self.currentUser.following.count forKey:FollowingCountKey];
//                [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.following forKey:FollowingKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (completion) {
                    completion(YES);
                }
            } else if (returnCode == 20) {
                // error
                if (completion) {
                    completion(NO);
                }
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
    
    [uploadTask resume];
}

- (void)changeUsernameUsingString:(id)newUsername andCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li&username=%@", self.currentUser.userID, newUsername];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"update_username.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseDict.count > 0) {
                NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
                
                if (returnCode == 10) {
                    self.currentUser.username = newUsername;
                    [self saveUserLocal];
                    completion(YES, nil);
                } else if (returnCode == 20) {
                    completion(NO, @"That username is already taken.");
                } else {
                    completion(NO, @"Unable to change username at this time.");
                }
            } else {
                completion(NO, @"Unable to change username at this time.");
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

- (void)changeEmailUsingString:(id)newEmail andCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li&email=%@", self.currentUser.userID, newEmail];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"update_email.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseDict.count > 0) {
                NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
                
                if (returnCode == 10) {
                    self.currentUser.email = newEmail;
                    [self saveUserLocal];
                    completion(YES, nil);
                } else if (returnCode == 20) {
                    completion(NO, @"That email address is already in use.");
                } else {
                    completion(NO, @"Unable to change email at this time.");
                }
            } else {
                completion(NO, @"Unable to change email at this time.");
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

- (void)confirmPasswordUsingString:(id)password andCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li&passwd=%@", self.currentUser.userID, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"check_user_passwd.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseDict.count > 0) {
                NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
                
                if (returnCode == 10) {
                    completion(YES, nil);
                } else {
                    completion(NO, @"Incorrect password.");
                }
            } else {
                completion(NO, @"Unable to confirm password at this time.");
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

- (void)changePasswordUsingString:(id)password andCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li&passwd=%@", self.currentUser.userID, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"update_user_passwd.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseDict.count > 0) {
                NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
                
                if (returnCode == 10) {
                    completion(YES, nil);
                } else {
                    completion(NO, @"Unable to change password at this time.");
                }
            } else {
                completion(NO, @"Unable to change password at this time.");
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

@end
