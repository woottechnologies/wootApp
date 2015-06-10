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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.244:3399/woot/select_teams.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutTeams = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                   // NSLog(@"%@", dict);
                    Team *newTeam = [[Team alloc] initWithDictionary:dict];
                    [mutTeams addObject:newTeam];
                }
                self.teams = [mutTeams copy];
                self.currentTeam = self.teams[0];
                completion(YES);
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

- (void)loadCampaigns {
    CampaignController *campaignController = [CampaignController sharedInstance];
    [campaignController loadCampaignFromDBForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *campaigns) {
        if (success) {
            self.currentTeam.campaigns = campaigns;
            //
        }
    }];
}


- (NSArray *) mostViewedAthletes{
    //[self loadAthletes];
    NSMutableArray *mostViewed = [[NSMutableArray alloc] init];
    while (mostViewed.count < 5) {
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

- (void)loadAthletesFromDBWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)self.currentTeam.teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.244:3399/woot/select_athletes.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutAthletes = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                   // NSLog(@"%@", dict);
                    Athlete *newAthlete = [[Athlete alloc] initWithDictionary:dict];
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[PhotoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newAthlete.photo = image;
                        }
                    }];
                    [mutAthletes addObject:newAthlete];
                }
                //self.currentTeam.athletes = mutAthletes;
                self.currentTeam.athletes = [mutAthletes copy];
                completion(YES);
            }
        } else {
            completion(NO);
        }
    }];
    
    [uploadTask resume];
}

@end