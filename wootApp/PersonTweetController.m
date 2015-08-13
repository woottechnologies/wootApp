//
//  PersonTweetController.m
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonTweetController.h"
#import "PersonController.h"


@implementation PersonTweetController
+ (PersonTweetController *)sharedInstance {
    
    static PersonTweetController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PersonTweetController new];
    });
    return sharedInstance;
    
}

- (void)teamTweetNetworkController{
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        PersonController *personController = [PersonController sharedInstance];
        if (guestSession) {
            NSString *searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
//            self.handle = personController.currentPerson.twitter;
            NSDictionary *params = @{@"q" : self.handle};
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
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:teamTweetRequestFinished object:nil];
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

