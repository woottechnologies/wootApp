//
//  TeamController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamController.h"
#import "Athlete.h"
#import "SchoolController.h"
#import "CampaignController.h"
#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@interface TeamController()

@property (nonatomic, strong) NSArray *teams;

@end

@implementation TeamController

+ (instancetype)sharedInstance {
    static TeamController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TeamController alloc] init];
    });
    
    return sharedInstance;
}

- (void)loadTeamsFromDBWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"schoolID=%li", (long)[SchoolController sharedInstance].currentSchool.schoolID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_teams.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutTeams = [[NSMutableArray alloc] init];
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    Team *newTeam = [[Team alloc] initWithDictionary:dict];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[CoachingStaffPhotoKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newTeam.coachingStaffPhoto = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[AthleteHeaderPhotoKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newTeam.athleteHeaderPhoto = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[TeamHeaderPhotoKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newTeam.teamHeaderPhoto = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];

                    [mutTeams addObject:newTeam];
                }
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    self.teams = [mutTeams copy];
                    self.currentTeam = self.teams[0];
                    completion(YES);
                });
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

- (void)selectTeamWithTeamID:(NSInteger)teamID andCompletion:(void (^)(BOOL success, Team *team))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_team.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                Team *teamCreated;
                for (NSDictionary *dict in responseArray) {
                    teamCreated = [[Team alloc] initWithDictionary:dict];
                }
                completion(YES, teamCreated);
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

- (void)loadCampaigns {
    CampaignController *campaignController = [CampaignController sharedInstance];
    [campaignController loadCampaignsFromDBForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *campaigns) {
        if (success) {
            self.currentTeam.campaigns = campaigns;
        }
    }];
}


- (NSArray *) mostViewedAthletes{
    NSMutableArray *mostViewed = [[NSMutableArray alloc] init];
    while (mostViewed.count < 6) {
        Athlete *topAthlete = [Athlete new];
        topAthlete.views = -1;
        for (Athlete *athlete in self.currentTeam.athletes){
            if (athlete.views > topAthlete.views && ![mostViewed containsObject:athlete]) {
                topAthlete = athlete;
            }
        }
        [mostViewed addObject:topAthlete];
    }
    return mostViewed;
}

- (NSArray *) sortRosterByNumber{
    NSMutableArray *roster = [[NSMutableArray alloc] init];
    NSMutableArray *unsortedRoster = [self.currentTeam.athletes mutableCopy];
    while (roster.count < self.currentTeam.athletes.count){
        Athlete *athleteWithSmallestNumber = [Athlete new];
        athleteWithSmallestNumber.jerseyNumber = 999999;
        for (Athlete *athlete in unsortedRoster){
            if (athlete.jerseyNumber < athleteWithSmallestNumber.jerseyNumber){
                athleteWithSmallestNumber = athlete;
            }
        }
        [roster addObject:athleteWithSmallestNumber];
        [unsortedRoster removeObject:athleteWithSmallestNumber];
    }
    return roster;
}

#pragma mark - Athletes

- (void)loadAthletesFromDBWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)self.currentTeam.teamID];
    
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
                   // NSLog(@"%@", dict);
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
                    self.currentTeam.athletes = [mutAthletes copy];
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

#pragma mark - Coaches

- (void)loadCoachesFromDBWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)self.currentTeam.teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_coaches.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutCoaches = [[NSMutableArray alloc] init];
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    Coach *newCoach = [[Coach alloc] initWithDictionary:dict];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[PhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newCoach.photo = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    [mutCoaches addObject:newCoach];
                }
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    self.currentTeam.coaches = [mutCoaches copy];
                    completion(YES);
                });
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

@end