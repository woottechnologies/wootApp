//
//  CampaignController.h
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Campaign.h"
#import "TeamController.h"

@interface CampaignController : NSObject

@property (nonatomic, strong, readonly) NSArray *campaigns;
@property (nonatomic, strong) Campaign *currentCampaign;

+ (instancetype) sharedInstance;
- (void)loadCampaignsFromDBForTeam:(Team *)team WithCompletion:(void (^)(BOOL success, NSArray *campaigns))completion;
- (void)selectRandomCampaign;
- (void)incrementViewsWithAdType:(NSString *)adType;

@end
