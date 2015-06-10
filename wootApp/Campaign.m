//
//  Sponsor.m
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Campaign.h"

@implementation Campaign

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.campaignID = [dictionary[CampaignIDKey] integerValue];
        //self.bannerAd = dictionary[BannerAdKey];
        //self.fullScreenAd = dictionary[FullScreenAdKey];
    }
       
    return self;
}


@end
