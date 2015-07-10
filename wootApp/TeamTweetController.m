//
//  TeamTweets.m
//  wootApp
//
//  Created by Egan Anderson on 7/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamTweetController.h"


@implementation TeamTweetController
+ (TeamTweetController *)sharedInstance {
    
    static TeamTweetController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TeamTweetController new];
    });
    return sharedInstance;
    
}

- (void)networkController{
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession) {
            NSString *searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
            self.teamHashtag = @"#USMNT #Soccer";
            NSDictionary *params = @{@"q" : self.teamHashtag};
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
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"requestFinished" object:nil];
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
