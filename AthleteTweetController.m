//
//  AthleteTweetController.m
//  wootApp
//
//  Created by Egan Anderson on 7/15/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AthleteTweetController.h"
#import "AthleteController.h"

@implementation AthleteTweetController
+ (AthleteTweetController *)sharedInstance {
    
    static AthleteTweetController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AthleteTweetController new];
    });
    return sharedInstance;
    
}

- (void)athleteTweetNetworkController{
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        AthleteController *athleteController = [AthleteController sharedInstance];
        if (guestSession) {
            NSString *searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
            self.athleteHandle = athleteController.currentAthlete.twitter;
            NSDictionary *params = @{@"q" : self.athleteHandle};
            NSError *clientError;
            NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                                     URLRequestWithMethod:@"GET"
                                     URL:searchURL
                                     parameters:params
                                     error:&clientError];
            
            if (request) {
                [[[Twitter sharedInstance] APIClient]
                 sendTwitterRequest:request
                 completion:^(NSURLResponse *response,
                              NSData *data,
                              NSError *connectionError) {
                     if (data) {
                         // handle the response data e.g.
                         NSError *jsonError;
                         NSDictionary *searchResults = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                         
                         self.tweets = [TWTRTweet tweetsWithJSONArray:searchResults[@"statuses"]];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:athleteTweetRequestFinished object:nil];
                     }
                     else {
                         NSLog(@"Error: %@", connectionError);
                     }
                 }];
            }
            else {
                NSLog(@"Error: %@", clientError);
            }
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

@end

