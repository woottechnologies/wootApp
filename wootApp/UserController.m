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
                completion(NO, @"Email already exists");
            }
        } else {
            completion(NO, @"Error with network request");
        }
    }];
    
    [uploadTask resume];
}

- (void)saveUserLocal {
    NSDictionary *userDict = @{UserIDKey:[NSNumber numberWithInteger:self.currentUser.userID],
                               EmailKey:self.currentUser.email};
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.favorites forKey:FavoritesKey];

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
            dispatch_group_t favoritesGroup = dispatch_group_create();
            if (returnCode == 10) {
                NSInteger userID = [[responseDict objectForKey:@"id"] integerValue];
                NSString *email = [responseDict objectForKey:@"email"];
                self.currentUser.userID = userID;
                self.currentUser.email = email;
                self.currentUser.password = nil;
                dispatch_group_enter(favoritesGroup);
                [self loadFavoritesFromDBWithCompletion:^(BOOL success, NSArray *favorites) {
                    if (success) {
                        self.currentUser.favorites = favorites;
                        [self saveUserLocal];
                    }
                    dispatch_group_leave(favoritesGroup);
                }];
                dispatch_group_notify(favoritesGroup, dispatch_get_main_queue(), ^{
                    completion(YES, nil);
                });
            } else if (returnCode == 20) {
                completion(NO, @"Incorrect username or password");
            } else {
                completion(NO, @"No user found");
            }
        } else {
            completion(NO, @"Error with network request");
        }
    }];
    
    [uploadTask resume];
}

- (void)loadFavoritesFromDBWithCompletion:(void (^)(BOOL success, NSArray *favorites))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li", self.currentUser.userID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_favorites.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutFavorites = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                    NSNumber *favID = [NSNumber numberWithInteger:[[dict objectForKey:FavIDKey] integerValue]];
                    NSString *name = [dict objectForKey:FavNameKey];
                    NSString *type = [dict objectForKey:FavTypeKey];
                    
                    NSDictionary *favoriteDict = @{FavIDKey:favID, FavNameKey:name, FavTypeKey:type};
                    [mutFavorites addObject:favoriteDict];
                }
                completion(YES, mutFavorites);
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
    }
    
    NSDictionary *favoritesLocal = [[NSUserDefaults standardUserDefaults] objectForKey:FavoritesKey];
    NSMutableArray *mutFavorites = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in favoritesLocal) {
        [mutFavorites addObject:dict];
    }
    
    self.currentUser.favorites = mutFavorites;
}

#pragma mark - Update

- (void)addFavorite:(id)favorite {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableArray *tempFavorites = [[NSMutableArray alloc] initWithArray:self.currentUser.favorites];
    
    NSDictionary *newFavoriteDict; // for local
    NSString *postString;          // for database
    
    if ([favorite isKindOfClass:[Team class]]) {
        Team *newFavorite = favorite;
        
        newFavoriteDict = @{FavIDKey:[NSNumber numberWithInteger:newFavorite.teamID],
                            FavNameKey:[SchoolController sharedInstance].currentSchool.name,
                            FavTypeKey:@"T"};
        
        postString = [NSString stringWithFormat:@"userID=%li&favoriteID=%li&favoriteType=T", (long)self.currentUser.userID, (long)newFavorite.teamID];
    } else {
        Athlete *newFavorite = favorite;
        
        newFavoriteDict = @{FavIDKey:[NSNumber numberWithInteger:newFavorite.athleteID],
                            FavNameKey:newFavorite.name,
                            FavTypeKey:@"A"};
        
        postString = [NSString stringWithFormat:@"userID=%li&favoriteID=%li&favoriteType=A", (long)self.currentUser.userID, (long)newFavorite.athleteID];
    }
    
    // local
    [tempFavorites addObject:newFavoriteDict];
    self.currentUser.favorites = tempFavorites;
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.favorites forKey:FavoritesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // database
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"insert_favorite.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
            
            if (returnCode == 10) {
                // success
            } else if (returnCode == 20) {
               // error
            }
        } else {
           // completion(NO, @"Error with network request");
        }
    }];
    
    [uploadTask resume];
}

- (void)removeFavorite:(id)favorite {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableArray *tempFavorites = [[NSMutableArray alloc] initWithArray:self.currentUser.favorites];
    
    NSDictionary *oldFavoriteDict; // for local
    NSString *postString;          // for database
    
    if ([favorite isKindOfClass:[Team class]]) {
        Team *oldFavorite = favorite;
        
        oldFavoriteDict = @{FavIDKey:[NSNumber numberWithInteger:oldFavorite.teamID],
                            FavNameKey:[SchoolController sharedInstance].currentSchool.name,
                            FavTypeKey:@"T"};
        
        postString = [NSString stringWithFormat:@"userID=%li&favoriteID=%li&favoriteType=T", (long)self.currentUser.userID, (long)oldFavorite.teamID];
    } else {
        Athlete *oldFavorite = favorite;
        
        oldFavoriteDict = @{FavIDKey:[NSNumber numberWithInteger:oldFavorite.athleteID],
                            FavNameKey:oldFavorite.name,
                            FavTypeKey:@"A"};
        
        postString = [NSString stringWithFormat:@"userID=%li&favoriteID=%li&favoriteType=A", (long)self.currentUser.userID, (long)oldFavorite.athleteID];        
    }
    
    // local
    [tempFavorites removeObject:oldFavoriteDict];
    
    self.currentUser.favorites = tempFavorites;
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.favorites forKey:FavoritesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // database
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"delete_favorite.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
            
            if (returnCode == 10) {
                // success
            } else if (returnCode == 20) {
                // error
            }
        } else {
            // completion(NO, @"Error with network request");
        }
    }];
    
    [uploadTask resume];
}

@end
