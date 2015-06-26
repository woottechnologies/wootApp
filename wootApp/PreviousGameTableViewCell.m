//
//  ScheduleTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PreviousGameTableViewCell.h"
#import "TeamController.h"
#import "UIView+FLKAutoLayout.h"

@interface PreviousGameTableViewCell ()

@property (nonatomic, strong) UIImageView *opponentLogo;
@property (nonatomic, strong) UILabel *opponentLabel;
@property (nonatomic, strong) UILabel *winLossLabel;
@property (nonatomic, strong) UILabel *scoreLabel;


@end

@implementation PreviousGameTableViewCell

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
        self.opponentLogo = [[UIImageView alloc] init];
        self.opponentLabel = [[UILabel alloc] init];
        self.scoreLabel = [[UILabel alloc] init];
        self.winLossLabel = [[UILabel alloc] init];

        
        [self.contentView addSubview:self.opponentLabel];
        [self.contentView addSubview:self.opponentLogo];
        [self.contentView addSubview:self.scoreLabel];
        [self.contentView addSubview:self.winLossLabel];
        
        [self.opponentLogo alignTop:@"0" leading:@"15" toView:self.contentView];
        [self.opponentLogo alignBottomEdgeWithView:self.contentView predicate:@"0"];
        [self.opponentLogo constrainAspectRatio:@"0"];
        
        [self.opponentLabel constrainLeadingSpaceToView:self.opponentLogo predicate:@"20"];
        [self.opponentLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
        [self.opponentLabel constrainTrailingSpaceToView:self.scoreLabel predicate:@"10"];
        
        [self.scoreLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
        [self.scoreLabel constrainLeadingSpaceToView:self.opponentLabel predicate:@"10"];
        [self.scoreLabel constrainWidth:@"80"];
        
        [self.winLossLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
        [self.winLossLabel alignTrailingEdgeWithView:self.contentView predicate:@"15"];
        [self.winLossLabel constrainLeadingSpaceToView:self.scoreLabel predicate:@"10"];
        [self.winLossLabel constrainWidth:@"50"];


//        [self setUpCell:game];
    }
    return self;
}

- (void)setUpCell:(Game *) game{
    TeamController *teamController = [TeamController sharedInstance];
    
    BOOL isHomeTeam = (game.homeTeamID == teamController.currentTeam.teamID);
    if (isHomeTeam) {
        self.opponentLabel.text = [NSString stringWithFormat:@"%@",game.opposingSchool];
    } else {
        self.opponentLabel.text = [NSString stringWithFormat:@"@%@",game.opposingSchool];
    }
    
    self.opponentLogo.image = game.opposingLogo;
    
    self.scoreLabel.text = game.currentScore;
    
    if (game.winningTeamID == teamController.currentTeam.teamID){
        self.winLossLabel.text = @"W";
    } else if (game.winningTeamID){
        self.winLossLabel.text = @"L";
    } else {
        self.winLossLabel.text = @"D";
    }
    
}

@end
