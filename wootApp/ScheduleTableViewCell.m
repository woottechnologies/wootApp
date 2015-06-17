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
        [self setUpCell:game];
    }
    return self;
}

- (void)setUpCell:(Game *) game{
    TeamController *teamController = [TeamController sharedInstance];
    
//    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = game.date;
    [self.contentView addSubview:dateLabel];
    
//    UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 30)];
    UILabel *opponentLabel = [[UILabel alloc]init];
    BOOL isHomeTeam = (game.homeTeam.teamID == teamController.currentTeam.teamID);
    if (isHomeTeam) {
        opponentLabel.text = [NSString stringWithFormat:@"%@",game.opposingSchool];
    } else {
        opponentLabel.text = [NSString stringWithFormat:@"@%@",game.opposingSchool];
    }
    [self.contentView addSubview:opponentLabel];
    
//    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 60, 30)];
    UILabel *scoreLabel = [[UILabel alloc]init];
    
//    UILabel *winLossLabel = [[UILabel alloc]initWithFrame:CGRectMake(300, 0, 40, 30)];
    UILabel *winLossLabel = [[UILabel alloc]init];
    
    if (game.isOver){
        scoreLabel.text = game.finalScore;
        [self.contentView addSubview:scoreLabel];
        
        if (game.winningTeam.teamID == teamController.currentTeam.teamID){
            winLossLabel.text = @"W";
        } else if (game.winningTeam.teamID){
            winLossLabel.text = @"L";
        } else {
            winLossLabel.text = @"D";
        }
        [self.contentView addSubview:winLossLabel];

    } else {
        scoreLabel.text = @"-";
        [self.contentView addSubview:scoreLabel];
        
        winLossLabel.text = @"-";
        [self.contentView addSubview:winLossLabel];
    }
   
    [dateLabel alignLeadingEdgeWithView:self.contentView predicate:@"10"];
    [dateLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [dateLabel constrainWidth:@"100"];
    
    [opponentLabel constrainLeadingSpaceToView:dateLabel predicate:@"10"];
    [opponentLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [opponentLabel constrainTrailingSpaceToView:scoreLabel predicate:@"10"];
    
    [scoreLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [scoreLabel constrainTrailingSpaceToView:winLossLabel predicate:@"10"];
    [scoreLabel constrainWidth:@"60"];
    
    [winLossLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [winLossLabel alignTrailingEdgeWithView:self.contentView predicate:@"20"];
    [winLossLabel constrainWidth:@"30"];
    
   
    
    
}
@end
