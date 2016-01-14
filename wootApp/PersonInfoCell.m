//
//  PersonInfoCell.m
//  wootApp
//
//  Created by Egan Anderson on 8/19/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonInfoCell.h"
#import "UIView+FLKAutoLayout.h"

@interface PersonInfoCell ()

@end

@implementation PersonInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithInfoType:(NSString *)infoType infoValue:(NSString *)infoValue style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCellWithInfoType:infoType infoValue:infoValue];
    }
    return self;
}

- (void)setUpCellWithInfoType:(NSString *)infoType infoValue:(NSString *)infoValue{
    self.infoTypeLabel = [[UILabel alloc]init];
    self.infoTypeLabel.text = infoType;
    self.infoValueLabel = [[UILabel alloc]init];
    self.infoValueLabel.text = infoValue;
    self.infoValueLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.infoTypeLabel];
    [self.contentView addSubview:self.infoValueLabel];
    
    [self.infoTypeLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [self.infoTypeLabel alignLeadingEdgeWithView:self.contentView predicate:@"10"];
    [self.infoTypeLabel constrainWidth:@"50"];
    
    [self.infoValueLabel alignTop:@"0" bottom:@"0" toView:self.contentView];
    [self.infoValueLabel constrainLeadingSpaceToView:self.infoTypeLabel predicate:@"10"];
    [self.infoValueLabel alignTrailingEdgeWithView:self.contentView predicate:@"-10"];
    
}


@end
