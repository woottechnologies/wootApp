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
    NSString *password = self.currentUser.password;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&passwd=%@", email, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"insert_user.php"];
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
            }
        } else {
            completion(NO, @"No internet connection detected.");
        }
    }];
    
    [uploadTask resume];
}

- (void)saveUserLocal {
    NSDictionary *userDict = @{UserIDKey:[NSNumber numberWithInteger:self.currentUser.userID],
                               EmailKey:self.currentUser.email};
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.following forKey:FollowingKey];
    //[[NSUserDefaults standardUserDefaults] setObject:self.currentUser.favorites forKey:FavoritesKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Read

- (void)logInUserWithCompletion:(void (^)(BOOL success, NSString *error))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *email = self.currentUser.email;
    NSString *password = self.currentUser.password;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&passwd=%@", email, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_user.php"];
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
                NSString *email = [responseDict objectForKey:@"email"];
                self.currentUser.userID = userID;
                self.currentUser.email = email;
                self.currentUser.password = nil;
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
                completion(NO, @"Incorrect email or password. Please try again.");
            } else {
                completion(NO, @"Sorry. There are no users with that email address.");
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
        
        NSArray *followingLocal = [[NSUserDefaults standardUserDefaults] objectForKey:FollowingKey];
        self.currentUser.following = followingLocal;
        
    }
}

#pragma mark - Update

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
                [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.following forKey:FollowingKey];
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
                [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.following forKey:FollowingKey];
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

@end
