//
//  SearchController.m
//  wootApp
//
//  Created by Egan Anderson on 7/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//
#import "SearchController.h"
#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@interface SearchController()


@end

@implementation SearchController

+(instancetype) sharedInstance{
    static SearchController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SearchController alloc]init];
    });
    
    return sharedInstance;
}

- (void)searchTeamsWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"keyword=%@", self.schoolNameSearch];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"search_teams.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            if (responseArray.count > 0) {
                self.teams = responseArray;
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

//- (void)searchUsersWithCompletion:(void (^)(BOOL success))completion {
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSString *post = [NSString stringWithFormat:@"keyword=%@", self.userNameSearch];
//    
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"search_people.php"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        if (data.length > 0 && error == nil) {
//            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            
//            if (responseArray.count > 0) {
//                self.users = responseArray;
//                completion(YES);
//            } else {
//                completion(NO);
//            }
//        } else {
//            completion(NO);
//        }
//    }];
//    
//    [uploadTask resume];
//}

- (void)searchPeopleWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"keyword=%@", self.personNameSearch];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"search_people.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                self.people = responseArray;
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}



@end
