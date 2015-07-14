//
//  HomeFeedController.m
//  wootApp
//
//  Created by Egan Anderson on 7/13/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedController.h"
#import "NetworkController.h"
#import "SchoolController.h"


@implementation HomeFeedController

+ (instancetype)sharedInstance {
    static HomeFeedController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeFeedController alloc] init];
    });
    
    return sharedInstance;
}

- (void) loadHashtagsFromDBWithCompletion:(void (^)(BOOL success, NSArray *hashtags))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    NSString *post = [NSString stringWithFormat:@"userID=%li", self.currentUser.userID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_hashtag.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSString *hashtag;
                for (NSDictionary *dict in responseArray) {
                    NSString *hashtag = [dict objectForKey:HashtagKey];
                }
                completion(YES, hashtag);
            } else {
                completion(YES, nil);
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

- (void) loadTweetsFromHashtags{
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        NSMutableArray *mutableTweets = [[NSMutableArray alloc] init];
        if (guestSession) {
            for (NSString *hashtag in self.hashtags) {
                NSString *searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
                //            self.currentHashtag = @"#USMNT #Soccer";
                NSDictionary *params = @{@"q" : hashtag};
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
                             
                             [mutableTweets addObjectsFromArray:[TWTRTweet tweetsWithJSONArray:searchResults[@"statuses"]]];
                             
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
            }
            self.tweets = mutableTweets;
            [self sortTweetsChronologically];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

-(void) sortTweetsChronologically{
    NSMutableArray *sortedTweets = [[NSMutableArray alloc] init];
    NSMutableArray *unsortedTweets = [self.tweets mutableCopy];
        while (sortedTweets.count < unsortedTweets.count){
        TWTRTweet *oldestTweet = [TWTRTweet new];
        for (TWTRTweet *tweet in unsortedTweets){
            if ([tweet.createdAt compare:oldestTweet.createdAt] == NSOrderedDescending && ![sortedTweets containsObject:tweet]){
                oldestTweet = tweet;
            }
        }
        [sortedTweets addObject:oldestTweet];
    }
    self.tweets = sortedTweets;
}



@end
