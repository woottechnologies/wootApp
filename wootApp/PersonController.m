//
//  PersonController.m
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonController.h"
#import "NetworkController.h"
#import "UIImage+PathForFile.h"


@implementation PersonController

+ (instancetype)sharedInstance {
    static PersonController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PersonController alloc] init];
    });
    
    return sharedInstance;
}

- (void)selectPersonWithUserID:(NSInteger)userID andCompletion:(void (^)(BOOL success, Person *person))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"userID=%li", userID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_person.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                Person *personCreated;
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    personCreated = [[Person alloc] initWithDictionary:dict];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[PersonPhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            personCreated.photo = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[HeaderPhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            personCreated.headerPhoto = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                }
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    completion(YES, personCreated);
                });
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

- (void)incrementViewsForPersonWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"personID=%li", (long)self.currentPerson.personID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"update_athlete_views.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSInteger returnCode = [responseDict[@"returnCode"] integerValue];
            NSInteger views = [responseDict[@"views"] integerValue];
            
            if (returnCode == 10) {
                // success
                self.currentPerson.views = views;
                completion(YES);
            } else {
                // error
                completion(NO);
            }
        } else {
            // error
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

@end
