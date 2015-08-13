//
//  PersonTweetCell.m
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonTweetCell.h"

@interface PersonTweetCell ()

@property (nonatomic, strong) TWTRTweetView *tweetView;

@end

@implementation PersonTweetCell

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