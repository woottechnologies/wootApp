//
//  CampaignController.m
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CampaignController.h"
#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@interface CampaignController()

@property (nonatomic, strong) NSArray *campaigns;
@property (nonatomic) BOOL bannerReady;
@property (nonatomic) BOOL fullScreenReady;

@end

@implementation CampaignController

+(instancetype) sharedInstance{
    static CampaignController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CampaignController alloc]init];
            });
    return sharedInstance;
}

- (void)loadCampaignsFromDBForTeam:(Team *)team WithCompletion:(void (^)(BOOL success, NSArray *campaigns))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)team.teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_campaigns.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutCampaigns = [[NSMutableArray alloc] init];
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    Campaign *newCampaign = [[Campaign alloc] initWithDictionary:dict];
                    
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[BannerAdKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newCampaign.bannerAd = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[FullScreenAdKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newCampaign.fullScreenAd = image;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    
                    // [mutCampaigns addObject:newCampaign];
                    if ([dict[TierKey] integerValue] == 1) {
                        for(int i = 0; i < 3; i++) {
                            [mutCampaigns addObject:newCampaign];
                        }
                    } else if ([dict[TierKey] integerValue] == 2) {
                        for(int i = 0; i < 2; i++) {
                            [mutCampaigns addObject:newCampaign];
                        }
                    } else {
                        // tier 3
                        [mutCampaigns addObject:newCampaign];
                    }
                }
                
                dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
                    self.campaigns = mutCampaigns;
                    completion(YES, self.campaigns);
                });
            }
        } else {
            completion(NO, nil);
        }
    }];
    
    [uploadTask resume];
}

- (Campaign *)selectRandomCampaign:(NSArray *)campaigns{
    Campaign * currentCampaign = campaigns[arc4random_uniform((int)campaigns.count)];
    return currentCampaign;
}
         
@end
