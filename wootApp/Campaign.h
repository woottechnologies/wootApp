//
//  Sponsor.h
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSString *CampaignIDKey = @"id";
static NSString *BannerAdKey = @"bannerAd";
static NSString *FullScreenAdKey = @"fullScreenAd";
static NSString *TierKey = @"tier";

@interface Campaign : NSObject

@property (nonatomic, assign) NSInteger campaignID;
@property (nonatomic, strong) UIImage *bannerAd;
@property (nonatomic, strong) UIImage *fullScreenAd;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
