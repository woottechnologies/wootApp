//
//  GameController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "GameController.h"

@implementation GameController

+ (instancetype)sharedInstance {
    static GameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameController alloc] init];
    });
    
    return sharedInstance;
}

- (void)allGamesForTeam:(Team *)team WithCompletion:(void (^)(BOOL success, NSArray *games))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)team.teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.244:3399/woot/select_games.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutGames = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                    Game *newGame = [[Game alloc] initWithDictionary:dict];
                    [mutGames addObject:newGame];
                }
                NSArray *gameArray = [mutGames copy];
                completion(YES, gameArray);
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

@end
