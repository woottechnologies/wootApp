//
//  NextGameTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/26/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "NextGameTableViewCell.h"
#import "TeamController.h"
#import "UIView+FLKAutoLayout.h"

@interface NextGameTableViewCell ()

@property (nonatomic, strong) UIImageView *opponentLogo;
@property (nonatomic, strong) UILabel *opponentLabel;
@property (nonatomic, strong) UILabel *dateLabel;



@end

@implementation NextGameTableViewCell

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
        self.dateLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:self.opponentLabel];
        [self.contentView addSubview:self.opponentLogo];
        [self.contentView addSubview:self.dateLabel];
        
        [self.opponentLogo alignTop:@"0" leading:@"15" toView:self.contentView];
        [self.opponentLogo alignBottomEdgeWithView:self.contentView predicate:@"0"];
        [self.opponentLogo constrainAspectRatio:@"0"];
        
        [self.opponentLabel constrainLeadingSpaceToView:self.opponentLogo predicate:@"20"];
        [self.opponentLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
        [self.opponentLabel constrainTrailingSpaceToView:self.dateLabel predicate:@"10"];
        
        [self.dateLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
        [self.dateLabel alignTrailingEdgeWithView:self.contentView predicate:@"15"];
        [self.dateLabel constrainLeadingSpaceToView:self.opponentLabel predicate:@"10"];
        [self.dateLabel constrainWidth:@"140"];
        
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

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.dateLabel.text = game.dateString;

}
@end
