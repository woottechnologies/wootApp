//
//  ScheduleTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "TeamController.h"


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
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
    dateLabel.text = game.date;
    [self addSubview:dateLabel];
    
    UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 30)];
    BOOL isHomeTeam = (game.homeTeam.teamID == teamController.currentTeam.teamID);
    if (isHomeTeam) {
        opponentLabel.text = [NSString stringWithFormat:@"%@",game.awayTeam];
    } else {
        opponentLabel.text = [NSString stringWithFormat:@"@%@",game.homeTeam];
    }
    [self addSubview:opponentLabel];
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 60, 30)];
    
    UILabel *winLossLabel = [[UILabel alloc]initWithFrame:CGRectMake(300, 0, 40, 30)];
    
    if (game.isOver){
        scoreLabel.text = game.finalScore;
        [self addSubview:scoreLabel];
        
        if (game.winningTeam.teamID == teamController.currentTeam.teamID){
            winLossLabel.text = @"W";
        } else if (game.winningTeam.teamID){
            winLossLabel.text = @"L";
        } else {
            winLossLabel.text = @"D";
        }
        [self addSubview:winLossLabel];

    } else {
        scoreLabel.text = @"-";
        [self addSubview:scoreLabel];
        
        winLossLabel.text = @"-";
        [self addSubview:winLossLabel];
    }
    
}
@end
