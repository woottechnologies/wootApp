//
//  TeamTweetCell.m
//  wootApp
//
//  Created by Egan Anderson on 7/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamTweetCell.h"

@interface TeamTweetCell ()

@property (nonatomic, strong) TWTRTweetView *tweetView;

@end

@implementation TeamTweetCell

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
    self.tweetView = [[TWTRTweetView alloc] initWithTweet:nil style:TWTRTweetViewStyleCompact];
    return self;
}

- (void)setUpTweetCell:(TWTRTweet *) tweet{
    [self.tweetView configureWithTweet:tweet];
    self.tweetView.frame = CGRectMake(0, 0, 375, [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.bounds)]);
    [self.contentView addSubview:self.tweetView];
}

@end