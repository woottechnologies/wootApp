//
//  CustomTabBarVC.h
//  wootApp
//
//  Created by Cole Wilkes on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarVC : UITabBarController

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIButton *campaignAdButton;

- (void)chooseCampaign;

@end
