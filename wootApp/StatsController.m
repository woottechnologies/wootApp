//
//  StatsController.m
//  wootApp
//
//  Created by Egan Anderson on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "StatsController.h"
#import "TeamController.h"
#import "NetworkController.h"

@interface StatsController()

@property (nonatomic, strong) NSArray *stats;

@end

@implementation StatsController

+(instancetype) sharedInstance{
    static StatsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StatsController alloc]init];
    });
    return sharedInstance;
}

- (void)loadSummaryStatsFromDBForAthlete:(Athlete *)athlete WithCompletion:(void (^)(BOOL success, NSArray *stats))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"athleteID=%li", (long)athlete.athleteID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_summary_stats.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (responseArray.count > 0) {
                NSMutableArray *mutSummaryStats = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                    Stats *newStats = [[Stats alloc] initWithDictionary:dict];
                    [mutSummaryStats addObject:newStats];
                }
                self.stats = mutSummaryStats;
                completion(YES, self.stats);
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

@end
