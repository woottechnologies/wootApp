//
//  ScheduleTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "TeamController.h"
#import "UIView+FLKAutoLayout.h"


@implementation ScheduleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithGame:(Game *)game style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(!game){
            return self;
        }
        [self setUpCell:game];
    }
    return self;
}

- (void)setUpCell:(Game *) game{
    TeamController *teamController = [TeamController sharedInstance];
    
    UILabel *opponentLabel = [[UILabel alloc]init];
    BOOL isHomeTeam = (game.homeTeamID == teamController.currentTeam.teamID);
    if (isHomeTeam) {
        opponentLabel.text = [NSString stringWithFormat:@"%@",game.opposingSchool];
    } else {
        opponentLabel.text = [NSString stringWithFormat:@"@%@",game.opposingSchool];
    }
    [self.contentView addSubview:opponentLabel];
    
    UIImageView *opponentLogo = [[UIImageView alloc] initWithImage:game.opposingLogo];
    [self.contentView addSubview:opponentLogo];
    
    UIView *dateOrScoreView = [[UIView alloc] init];
    UILabel *dateLabel;
    UILabel *winLossLabel;
    UILabel *scoreLabel;

    if(!game.isOver) {
//        winLossLabel = nil;
//        scoreLabel = nil;
        dateLabel = [[UILabel alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
//        NSString *dateString = [dateFormatter stringFromDate:game.date];
        dateLabel.text = game.dateString;
        [dateOrScoreView addSubview:dateLabel];
        [dateLabel alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:dateOrScoreView];
    } else {
//        dateLabel = nil;
        scoreLabel = [[UILabel alloc] init];
        scoreLabel.text = game.currentScore;
        [dateOrScoreView addSubview:scoreLabel];
        [scoreLabel alignTop:@"0" bottom:@"0" toView:dateOrScoreView];
        [scoreLabel alignLeadingEdgeWithView:dateOrScoreView predicate:@"0"];
        
        winLossLabel = [[UILabel alloc] init];
        if (game.winningTeamID == teamController.currentTeam.teamID){
            winLossLabel.text = @"W";
        } else if (game.winningTeamID){
            winLossLabel.text = @"L";
        } else {
            winLossLabel.text = @"D";
        }
        [dateOrScoreView addSubview:winLossLabel];
        [winLossLabel alignTop:@"0" bottom:@"0" toView:dateOrScoreView];
        [winLossLabel alignTrailingEdgeWithView:dateOrScoreView predicate:@"0"];
        [winLossLabel constrainLeadingSpaceToView:scoreLabel predicate:@"20"];
    }
    [self.contentView addSubview:dateOrScoreView];
    
    [opponentLogo alignTop:@"0" leading:@"15" toView:self.contentView];
    [opponentLogo alignBottomEdgeWithView:self.contentView predicate:@"0"];
    [opponentLogo constrainAspectRatio:@"0"];

    [opponentLabel constrainLeadingSpaceToView:opponentLogo predicate:@"10"];
    [opponentLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [opponentLabel constrainTrailingSpaceToView:dateOrScoreView predicate:@"10"];
    
    [dateOrScoreView alignTop:@"0" bottom:@"0" toView:self.contentView];
    [dateOrScoreView alignTrailingEdgeWithView:self.contentView predicate:@"15"];
    [dateOrScoreView constrainLeadingSpaceToView:opponentLabel predicate:@"10"];
    [dateOrScoreView constrainWidth:@"150"];
}
@end
