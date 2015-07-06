//
//  SchoolListTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 7/2/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SchoolListTableViewCell.h"
#import "UIView+FLKAutoLayout.h"

@interface SchoolListTableViewCell ()

@end

@implementation SchoolListTableViewCell

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
        self.cellImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.cellImage];
        [self.cellImage alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    }
    return self;
}

- (void)setUpCell:(School *) school{
    self.cellImage.image = school.banner;
}

@end
