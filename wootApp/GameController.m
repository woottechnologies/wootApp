//
//  GameController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "GameController.h"
#import "NetworkController.h"
#import "UIImage+PathForFile.h"

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
    
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_games_2.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                dispatch_group_t imageGroup = dispatch_group_create();
                NSMutableArray *mutGames = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in responseArray) {
                    Game *newGame = [[Game alloc] initWithDictionary:dict];
                    
                    dispatch_group_enter(imageGroup);
                    NSString *logoPath = dict[OpposingLogoKey];
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", logoPath] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newGame.opposingLogo = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    [mutGames addObject:newGame];
                }
                
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    NSArray *gameArray = [mutGames copy];
                    completion(YES, gameArray);
                });
            }
        } else {
            completion(NO, nil);
        }
    }];
    
   
    
    [uploadTask resume];
}

@end
