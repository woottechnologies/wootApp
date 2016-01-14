
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
#import "UserController.h"
#import "HomeFeedViewController.h"


@implementation HomeFeedController

+ (instancetype)sharedInstance {
    static HomeFeedController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeFeedController alloc] init];
    });
    
    return sharedInstance;
}

//- (void) loadHashtagsFromDBWithCompletion:(void (^)(BOOL success, NSArray *hashtags))completion {
//    NSURLSession *session = [NSURLSession sharedSession];
//
//
//
//    NSString *post = [NSString stringWithFormat:@"userID=%li", self.currentUser.userID];
//
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_hashtag.php"];
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
//                NSString *hashtag;
//                for (NSDictionary *dict in responseArray) {
//                    NSString *hashtag = [dict objectForKey:HashtagKey];
//                }
//                completion(YES, hashtag);
//            } else {
//                completion(YES, nil);
//            }
//        } else {
//            completion(NO, nil);
//        }
//    }];
//
//    [uploadTask resume];
//}

- (void) loadTweetsFromHashtagsWithCompletion:(void (^)(BOOL success))completion {
    User *currentUser = [UserController sharedInstance].currentUser;
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        NSMutableArray *mutableTweets = [[NSMutableArray alloc] init];
        NSMutableArray *mutableTweetsNoRetweets = [[NSMutableArray alloc] init];
        NSMutableArray *tweetsAndNames = [[NSMutableArray alloc] init];
        if (guestSession) {
            dispatch_group_t tweetGroup = dispatch_group_create();
//            dispatch_group_enter(tweetGroup);
            for (NSDictionary *following in currentUser.following) {
                NSString *searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
                //            self.currentHashtag = @"#USMNT #Soccer";
                NSDictionary *params = @{@"q" : following[FollowingTwitterKey]};
                NSError *clientError;
                NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                                         URLRequestWithMethod:@"GET"
                                         URL:searchURL
                                         parameters:params
                                         error:&clientError];
                
                if (request) {
                    dispatch_group_enter(tweetGroup);
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
                             for (TWTRTweet *tweet in mutableTweets) {
                                 if (!tweet.isRetweet) {
                                     [mutableTweetsNoRetweets addObject:tweet];
                                     [tweetsAndNames addObject:@{@"tweetID":tweet.tweetID, @"name":following[FollowingNameKey], @"type":following[FollowingTypeKey], @"id":following[FollowingIDKey]}];
                                 }
                             }
                             dispatch_group_leave(tweetGroup);
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
//            dispatch_group_leave(tweetGroup);
            dispatch_group_notify(tweetGroup, dispatch_get_main_queue(), ^{
                self.posts = mutableTweetsNoRetweets;
                self.tweetsAndNames = tweetsAndNames;
                [self sortTweetsChronologically];
                completion(YES);
            });
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

-(void) sortTweetsChronologically{
    NSMutableArray *sortedTweets = [[NSMutableArray alloc] init];
    NSMutableArray *unsortedTweets = [self.posts mutableCopy];
    while (unsortedTweets.count > 0) {
        TWTRTweet *oldestTweet = unsortedTweets[0];
        for (TWTRTweet *tweet in unsortedTweets){
            if ([tweet.createdAt compare:oldestTweet.createdAt] == NSOrderedDescending){
                oldestTweet = tweet;
            }
        }
        [sortedTweets addObject:oldestTweet];
        [unsortedTweets removeObject:oldestTweet];
    }
    self.posts = sortedTweets;
}



@end

