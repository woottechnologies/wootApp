//
//  AthleteController.m
//  wootApp
//
//  Created by Cole Wilkes on 7/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AthleteController.h"
#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@implementation AthleteController

+ (instancetype)sharedInstance {
    static AthleteController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AthleteController alloc] init];
    });
    
    return sharedInstance;
}

- (void)loadAthletesFromDBWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)[TeamController sharedInstance].currentTeam.teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_athletes.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutAthletes = [[NSMutableArray alloc] init];
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    Athlete *newAthlete = [[Athlete alloc] initWithDictionary:dict];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[PhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newAthlete.photo = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    [mutAthletes addObject:newAthlete];
                }
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    [TeamController sharedInstance].currentTeam.athletes = [mutAthletes copy];
                    completion(YES);
                });
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

- (void)selectAthleteWithAthleteID:(NSInteger)athleteID andCompletion:(void (^)(BOOL success, Athlete *athlete))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"athleteID=%li", athleteID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_athlete.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                Athlete *athleteCreated;
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    athleteCreated = [[Athlete alloc] initWithDictionary:dict];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[PhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            athleteCreated.photo = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[AthleteHeaderPhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            [TeamController sharedInstance].currentTeam = [[Team alloc] init];
                            [TeamController sharedInstance].currentTeam.athleteHeaderPhoto = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                }
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    completion(YES, athleteCreated);
                });
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

- (void)incrementViewsForAthleteWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"athleteID=%li", (long)self.currentAthlete.athleteID];
    
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
                self.currentAthlete.views = views;
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
