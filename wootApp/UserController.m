//
//  UserController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UserController.h"
#import "NetworkController.h"

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

#pragma Create

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
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:@"userDict"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma Read

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
            
            if (returnCode == 10) {
                NSInteger userID = [[responseDict objectForKey:@"id"] integerValue];
                NSString *email = [responseDict objectForKey:@"email"];
                self.currentUser.userID = userID;
                self.currentUser.email = email;
                self.currentUser.password = nil;
                [self saveUserLocal];
                completion(YES, nil);
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

- (void)loadUserLocal {
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDict"];
    
    if (userDict == nil) {
        self.currentUser = nil;
    } else {
        self.currentUser = [[User alloc] initWithDictionary:userDict];
    }
}

@end
