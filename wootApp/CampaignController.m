//
//  CampaignController.m
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CampaignController.h"
#import "UIImage+PathForFile.h"

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

- (void)loadCampaignFromDBForTeam:(Team *)team WithCompletion:(void (^)(BOOL success, NSArray *campaigns))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *post = [NSString stringWithFormat:@"teamID=%li", (long)team.teamID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8888/woot/select_campaigns.php"]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.244:3399/woot/select_campaigns.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutCampaigns = [[NSMutableArray alloc] init];
//                self.bannerReady = NO;
//                self.fullScreenReady = NO;
                dispatch_group_t imageGroup = dispatch_group_create();
                for (NSDictionary *dict in responseArray) {
                    // NSLog(@"%@", dict);
                    Campaign *newCampaign = [[Campaign alloc] initWithDictionary:dict];
                    
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[BannerAdKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newCampaign.bannerAd = image;
//                            self.bannerReady = YES;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    dispatch_group_enter(imageGroup);
                    [UIImage imageWithPath:dict[FullScreenAdKey] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newCampaign.fullScreenAd = image;
//                            self.fullScreenReady = YES;
                        }
                        dispatch_group_leave(imageGroup);
                    }];
                    [mutCampaigns addObject:newCampaign];
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
