//
//  TestViewController.m
//  wootApp
//
//  Created by Egan Anderson on 7/1/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+FLKAutoLayout.h"
#import "DynamicFontSize.h"
@import UIKit;


@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float windowWidth = self.view.frame.size.width;
    float headerPhotoBottom = windowWidth/2.083;
    float bigStripeHeight = windowWidth/8.333;
    float littleStripeHeight = windowWidth/46.875;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:nil];
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.1;
    [backButton addTarget:self action:nil
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, headerPhotoBottom + bigStripeHeight + littleStripeHeight + bigStripeHeight)];
    [self.view addSubview:headerView];
    
    UIImageView *headerPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_header_image.jpg"]];
    headerPhoto.frame = CGRectMake(0, 0, windowWidth, headerPhotoBottom);
    [headerView addSubview:headerPhoto];
    
    UIView *statusBarStripe = [[UIView alloc] init];
    statusBarStripe.backgroundColor = [UIColor whiteColor];
    statusBarStripe.frame = CGRectMake(0, 0, windowWidth, 20);
    [self.view addSubview:statusBarStripe];
    
    UIView *primaryColorStripe = [[UIView alloc] init];
    primaryColorStripe.backgroundColor = [UIColor blueColor];
    primaryColorStripe.frame = CGRectMake(0, headerPhotoBottom + bigStripeHeight + littleStripeHeight, windowWidth, bigStripeHeight);
    [headerView addSubview:primaryColorStripe];
    
    UIView *secondaryColorStripe = [[UIView alloc] init];
    secondaryColorStripe.backgroundColor = [UIColor redColor];
    secondaryColorStripe.frame = CGRectMake(0, headerPhotoBottom + bigStripeHeight, windowWidth, littleStripeHeight);
    [headerView addSubview:secondaryColorStripe];
    
    UIView *whiteStripe = [[UIView alloc] init];
    whiteStripe.backgroundColor = [UIColor whiteColor];
    whiteStripe.frame = CGRectMake(0, headerPhotoBottom, self.view.frame.size.width, bigStripeHeight);
    [headerView addSubview:whiteStripe];
    
    UIImageView *whiteCircle = [UIImageView new];
    whiteCircle.backgroundColor = [UIColor whiteColor];
    [self setRoundedView:whiteCircle toDiameter:windowWidth/2.083];
    CGPoint circleCenter = whiteCircle.center;
    circleCenter.x = windowWidth/4 + 6;
    circleCenter.y = headerPhotoBottom;
    whiteCircle.center = circleCenter;
    [headerView addSubview:whiteCircle];
    
    UIImageView *athleteCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"football_portrait_square"]];
    athleteCircle.clipsToBounds = YES;
    [self setRoundedView:athleteCircle toDiameter:windowWidth/2.388];
    athleteCircle.center = circleCenter;
    [headerView addSubview:athleteCircle];
    
    UILabel *athleteNumberLabel = [[UILabel alloc] init];
    athleteNumberLabel.frame = CGRectMake(windowWidth/2, windowWidth/93.75, windowWidth/6.25, windowWidth/10.135);
    athleteNumberLabel.text = @"#88";
    athleteNumberLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35];
    [athleteNumberLabel setFont:[athleteNumberLabel.font fontWithSize:[self maxFontSize:athleteNumberLabel]]];
    [whiteStripe addSubview:athleteNumberLabel];
    
    UILabel *athleteNameLabel = [[UILabel alloc] init];
    athleteNameLabel.frame = CGRectMake(athleteNumberLabel.center.x + windowWidth/10.714, windowWidth/75, windowWidth/3.261, windowWidth/17.8571429);
    athleteNameLabel.text = @"Luke Robinson";
    athleteNameLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    [athleteNameLabel setFont:[athleteNameLabel.font fontWithSize:[self maxFontSize:athleteNameLabel]]];
    [whiteStripe addSubview:athleteNameLabel];
    
    UILabel *athletePositionLabel = [[UILabel alloc] init];
    athletePositionLabel.frame = CGRectMake(athleteNumberLabel.center.x + windowWidth/10.714, windowWidth/16.304, windowWidth/3.261, windowWidth/25);
    athletePositionLabel.text = @"Senior QB";
    athletePositionLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
    [athletePositionLabel setFont:[athletePositionLabel.font fontWithSize:[self maxFontSize:athletePositionLabel]]];
    [whiteStripe addSubview:athletePositionLabel];
}

- (CGFloat) maxFontSize:(UILabel *)label{
    CGSize initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    
    if (initialSize.width > label.frame.size.width ||
        initialSize.height > label.frame.size.height)
    {
        while (initialSize.width > label.frame.size.width ||
            initialSize.height > label.frame.size.height)
        {
            [label setFont:[label.font fontWithSize:label.font.pointSize - 1]];
            initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        }
    } else {
        while (initialSize.width < label.frame.size.width &&
            initialSize.height < label.frame.size.height)
        {
            [label setFont:[label.font fontWithSize:label.font.pointSize + 1]];
            initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        }
        // went 1 point too large so compensate here
        [label setFont:[label.font fontWithSize:label.font.pointSize - 1]];
    }
    return label.font.pointSize;
}

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}



@end
