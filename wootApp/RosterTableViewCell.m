//
//  RosterTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/12/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "RosterTableViewCell.h"
#import "UIView+FLKAutoLayout.h"

@implementation RosterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithAthlete:(Athlete *)athlete style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCell:athlete];
    }
    return self;
}

- (void)setUpCell:(Athlete *)athlete{
    UILabel *jerseyNumberLabel = [[UILabel alloc]init];
    jerseyNumberLabel.text = [NSString stringWithFormat:@"#%li", athlete.jerseyNumber];
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = athlete.name;
//    UILabel *positionLabel = [[UILabel alloc]init];
//    positionLabel.text = athlete.position;
//    positionLabel.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:jerseyNumberLabel];
    [self.contentView addSubview:nameLabel];
//    [self.contentView addSubview:positionLabel];
    
    [jerseyNumberLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [jerseyNumberLabel alignLeadingEdgeWithView:self.contentView predicate:@"10"];
    [jerseyNumberLabel constrainWidth:@"50"];
    
    [nameLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [nameLabel constrainLeadingSpaceToView:jerseyNumberLabel predicate:@"0"];
    
//    [positionLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
//    [positionLabel constrainLeadingSpaceToView:nameLabel predicate:@"0"];
//    [positionLabel alignTrailingEdgeWithView:self.contentView predicate:@"0"];
//    [positionLabel constrainWidth:@"50"];
    
    
}

@end
