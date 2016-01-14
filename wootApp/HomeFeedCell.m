//
//  HomeFeedCell.m
//  wootApp
//
//  Created by Egan Anderson on 7/16/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedCell.h"
#import "UserController.h"
#import "TeamViewController.h"
#import "HomeFeedController.h"
#import "SchoolController.h"
#import "AthleteController.h"
#import "UIView+FLKAutoLayout.h"

@interface HomeFeedCell ()

@property (nonatomic, strong) TWTRTweetView *tweetView;
@property (nonatomic, strong) UIImageView *originalContentImage;
@property (nonatomic, strong) UILabel *originalContentCaption;
@property (nonatomic, strong) UIView *postView;
@property (nonatomic, strong) UILabel *posterName;
@property (nonatomic, strong) UIButton *posterNameButton;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) TWTRTweet *tweet;

@end

@implementation HomeFeedCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.postView = [[UIView alloc] init];
        self.tweetView = [[TWTRTweetView alloc] initWithTweet:nil style:TWTRTweetViewStyleCompact];
        self.originalContentImage = [[UIImageView alloc] init];
        self.originalContentCaption = [[UILabel alloc] init];
        self.originalContentCaption.numberOfLines = 0;
        //    self.posterName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width, 30)];
        self.posterNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        self.posterNameButton.frame = CGRectMake(5, 5, self.contentView.frame.size.width, 30);
        [self.posterNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.posterNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //    self.posterName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.posterNameButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        [self.posterNameButton addTarget:self action:@selector(posterNameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.posterNameButton.enabled = YES;
        self.grayView = [[UIView alloc] init];
        self.grayView.backgroundColor = [UIColor lightGrayColor];
        [self.postView addSubview:self.tweetView];
        [self.postView addSubview:self.originalContentImage];
        [self.postView addSubview:self.originalContentCaption];
        //    [self.postView addSubview:self.posterName];
        [self.postView addSubview:self.grayView];
        [self.postView addSubview:self.posterNameButton];
        [self.contentView addSubview:self.postView];
        
        [self.grayView alignTop:@"0" leading:@"0" toView:self.postView];
        [self.grayView alignTrailingEdgeWithView:self.postView predicate:@"0"];
        [self.grayView constrainHeight:@"5"];
        
        [self.posterNameButton constrainTopSpaceToView:self.grayView predicate:@"0"];
        [self.posterNameButton alignLeadingEdgeWithView:self.postView predicate:@"5"];
        [self.posterNameButton alignTrailingEdgeWithView:self.postView predicate:@"0"];
        [self.posterNameButton constrainHeight:@"30"];

        [self.postView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
        
    }
    return self;
}

- (void)setUpTweetCell:(TWTRTweet *)tweet posterInfo:(NSDictionary *)posterInfo{
    self.tweet = tweet;
    [self.tweetView configureWithTweet:tweet];
//    self.tweetView.frame = CGRectMake(0, 35, 375, [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.bounds)]);
//    self.grayView.frame = CGRectMake(0, 0, 375, 5);
//    self.posterName.text = posterInfo[FollowingNameKey];
    [self.posterNameButton setTitle:posterInfo[FollowingNameKey] forState:UIControlStateNormal];
    
    
    [self.tweetView constrainTopSpaceToView:self.posterNameButton predicate:@"0"];
    [self.tweetView alignLeading:@"0" trailing:@"0" toView:self.postView];
    NSString *tweetHeightString = [NSString stringWithFormat:@"%.2f", [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.bounds)]];
    [self.tweetView constrainHeight:tweetHeightString];
    [self.tweetView alignBottomEdgeWithView:self.postView predicate:@"0"];
}

- (void)setUpOriginalContentCell:(NSDictionary *)contents{
    [self.posterNameButton setTitle:contents[@"poster"] forState:UIControlStateNormal];
    [self.originalContentImage setImage:contents[@"image"]];
    self.originalContentCaption.text = contents[@"caption"];
    
    [self.originalContentImage constrainTopSpaceToView:self.posterNameButton predicate:@"0"];
    [self.originalContentImage alignLeading:@"0" trailing:@"0" toView:self.postView];
    [self.originalContentCaption constrainTopSpaceToView:self.originalContentImage predicate:@"0"];
    [self.originalContentCaption alignLeading:@"0" trailing:@"0" toView:self.postView];
    [self.originalContentCaption alignBottomEdgeWithView:self.postView predicate:@"0"];
}

- (void)posterNameButtonPressed:(id)sender {
    UIButton *button = sender;
    if (button.touchInside == YES) {
        HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
        NSDictionary *posterInfo;
        for (NSDictionary *tweetAndInfo in homeFeedController.tweetsAndNames) {
            if ([tweetAndInfo[@"tweetID"] isEqualToString:self.tweet.tweetID]) {
                posterInfo = tweetAndInfo;
                break;
            }
        }
        NSString *type = posterInfo[FollowingTypeKey];
        
        if ([type isEqualToString:@"T"]) {
            NSInteger teamID = [[posterInfo objectForKey:FollowingIDKey] integerValue];
            [[TeamController sharedInstance] selectTeamWithTeamID:teamID andCompletion:^(BOOL success, Team *team) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate teamNameButtonPressed:team];
                });
            }];

        } else {
            NSInteger athleteID = [[posterInfo objectForKey:FollowingIDKey] integerValue];
            [[AthleteController sharedInstance] selectAthleteWithAthleteID:athleteID andCompletion:^(BOOL success, Athlete *athlete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate athleteNameButtonPressed:athlete];
                });
            }];
        }
    }
}

@end
