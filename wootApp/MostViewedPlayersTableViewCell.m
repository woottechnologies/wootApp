//
//  MostViewedPlayersTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/4/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "MostViewedPlayersTableViewCell.h"
#import "TeamController.h"
#import "Athlete.h"
#import "UIView+FLKAutoLayout.h"

@interface MostViewedPlayersTableViewCell ()

@property (nonatomic, strong) NSArray *mostViewedAthletes;
@property (nonatomic, strong) UIImageView *athlete1ImageView;
@property (nonatomic, strong) UILabel *athlete1NameLabel;

@property (nonatomic, strong) UIImageView *athlete2ImageView;
@property (nonatomic, strong) UILabel *athlete2NameLabel;

@property (nonatomic, strong) UIImageView *athlete3ImageView;
@property (nonatomic, strong) UILabel *athlete3NameLabel;

@property (nonatomic, strong) UIImageView *athlete4ImageView;
@property (nonatomic, strong) UILabel *athlete4NameLabel;

@property (nonatomic, strong) UIImageView *athlete5ImageView;
@property (nonatomic, strong) UILabel *athlete5NameLabel;

@end

@implementation MostViewedPlayersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
//        self.frame = CGRectMake(0, 0, self.window.frame.size.width, self.athlete1View.frame.size.height * 2);
    }
    
    return self;
}

- (void)setupViews {
    // athlete1View
    self.athlete1View = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.athlete1View.tag = 0;
    [self.athlete1View addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.athlete1ImageView = [UIImageView new];
    self.athlete1NameLabel = [UILabel new];
    self.athlete1NameLabel.textAlignment = NSTextAlignmentCenter;
    self.athlete1NameLabel.font = [UIFont systemFontOfSize:13];
    [self.athlete1View addSubview:self.athlete1ImageView];
    [self.athlete1View addSubview:self.athlete1NameLabel];
    [self.athlete1ImageView alignTop:@"0" leading:@"0" toView:self.athlete1View];
    [self.athlete1ImageView alignTrailingEdgeWithView:self.athlete1View predicate:@"0"];
    [self.athlete1ImageView constrainHeightToView:self.athlete1View predicate:@"-15"];
    [self.athlete1NameLabel alignLeading:@"0" trailing:@"0" toView:self.athlete1View];
    [self.athlete1NameLabel constrainTopSpaceToView:self.athlete1ImageView predicate:@"0"];
    [self.athlete1NameLabel constrainHeight:@"15"];
    [self.contentView addSubview:self.athlete1View];
    
    // athlete2View
    
    self.athlete2View = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 //   self.athlete2View.frame = CGRectMake(self.frame.size.width / 3, 0, self.frame.size.width / 3, self.frame.size.width / 1.7);
    self.athlete2View.tag = 1;
    [self.athlete2View addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.athlete2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.athlete2View.frame.size.width, self.athlete2View.frame.size.height - 40)];
//    self.athlete2NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.athlete2View.frame.size.height - 40, self.frame.size.width - 20, 15)];
    self.athlete2ImageView = [UIImageView new];
    self.athlete2NameLabel = [UILabel new];
    self.athlete2NameLabel.textAlignment = NSTextAlignmentCenter;
    self.athlete2NameLabel.font = [UIFont systemFontOfSize:13];
    [self.athlete2View addSubview:self.athlete2ImageView];
    [self.athlete2View addSubview:self.athlete2NameLabel];
    [self.athlete2ImageView alignTop:@"0" leading:@"0" toView:self.athlete2View];
    [self.athlete2ImageView alignTrailingEdgeWithView:self.athlete2View predicate:@"0"];
    [self.athlete2ImageView constrainHeightToView:self.athlete2View predicate:@"-15"];
    [self.athlete2NameLabel alignLeading:@"0" trailing:@"0" toView:self.athlete2View];
    [self.athlete2NameLabel constrainTopSpaceToView:self.athlete2ImageView predicate:@"0"];
    [self.athlete2NameLabel constrainHeight:@"15"];
    [self.contentView addSubview:self.athlete2View];
    
    
    // athlete3View
    
    self.athlete3View = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 //   self.athlete3View.frame = CGRectMake(2 * self.frame.size.width / 3, 0, self.frame.size.width / 3, self.frame.size.width / 1.7);
    self.athlete3View.tag = 2;
    [self.athlete3View addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.athlete3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.athlete3View.frame.size.width, self.athlete3View.frame.size.height - 40)];
//    self.athlete3NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.athlete3View.frame.size.height - 40, self.frame.size.width - 20, 15)];
    self.athlete3ImageView = [UIImageView new];
    self.athlete3NameLabel = [UILabel new];
    self.athlete3NameLabel.textAlignment = NSTextAlignmentCenter;
    self.athlete3NameLabel.font = [UIFont systemFontOfSize:13];
    [self.athlete3View addSubview:self.athlete3ImageView];
    [self.athlete3View addSubview:self.athlete3NameLabel];
    [self.athlete3ImageView alignTop:@"0" leading:@"0" toView:self.athlete3View];
    [self.athlete3ImageView alignTrailingEdgeWithView:self.athlete3View predicate:@"0"];
    [self.athlete3ImageView constrainHeightToView:self.athlete3View predicate:@"-15"];
    [self.athlete3NameLabel alignLeading:@"0" trailing:@"0" toView:self.athlete3View];
    [self.athlete3NameLabel constrainTopSpaceToView:self.athlete3ImageView predicate:@"0"];
    [self.athlete3NameLabel constrainHeight:@"15"];
    [self.contentView addSubview:self.athlete3View];

    
    // athlete4View
    
    self.athlete4View = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // self.athlete4View.frame = CGRectMake(0, self.frame.size.width / 1.9, self.frame.size.width / 3, self.frame.size.width / 1.7);
    self.athlete4View.tag = 3;
    [self.athlete4View addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.athlete4ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.athlete4View.frame.size.width, self.athlete4View.frame.size.height - 40)];
//    self.athlete4NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.athlete4View.frame.size.height - 40, self.frame.size.width - 20, 15)];
    self.athlete4ImageView = [UIImageView new];
    self.athlete4NameLabel = [UILabel new];
    self.athlete4NameLabel.textAlignment = NSTextAlignmentCenter;
    self.athlete4NameLabel.font = [UIFont systemFontOfSize:13];
    [self.athlete4View addSubview:self.athlete4ImageView];
    [self.athlete4View addSubview:self.athlete4NameLabel];
    [self.contentView addSubview:self.athlete4View];
    [self.athlete4ImageView alignTop:@"0" leading:@"0" toView:self.athlete4View];
    [self.athlete4ImageView alignTrailingEdgeWithView:self.athlete4View predicate:@"0"];
    [self.athlete4ImageView constrainHeightToView:self.athlete4View predicate:@"-15"];
    [self.athlete4NameLabel alignLeading:@"0" trailing:@"0" toView:self.athlete4View];
    [self.athlete4NameLabel constrainTopSpaceToView:self.athlete4ImageView predicate:@"0"];

    
    // athlete5View
    
    self.athlete5View = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  //  self.athlete5View.frame = CGRectMake(self.frame.size.width / 3, self.frame.size.width / 1.9, self.frame.size.width / 3, self.frame.size.width / 1.7);
    self.athlete5View.tag = 4;
    [self.athlete5View addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.athlete5ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.athlete5View.frame.size.width, self.athlete5View.frame.size.height - 40)];
//    self.athlete5NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.athlete5View.frame.size.height - 40, self.frame.size.width - 20, 15)];
    self.athlete5ImageView = [UIImageView new];
    self.athlete5NameLabel = [UILabel new];
    self.athlete5NameLabel.textAlignment = NSTextAlignmentCenter;
    self.athlete5NameLabel.font = [UIFont systemFontOfSize:13];
    [self.athlete5View addSubview:self.athlete5ImageView];
    [self.athlete5View addSubview:self.athlete5NameLabel];
    [self addSubview:self.athlete5View];
    [self.athlete5ImageView alignTop:@"0" leading:@"0" toView:self.athlete5View];
    [self.athlete5ImageView alignTrailingEdgeWithView:self.athlete5View predicate:@"0"];
    [self.athlete5ImageView constrainHeightToView:self.athlete5View predicate:@"-15"];
    [self.athlete5NameLabel alignLeading:@"0" trailing:@"0" toView:self.athlete5View];
    [self.athlete5NameLabel constrainTopSpaceToView:self.athlete5ImageView predicate:@"0"];

    
    
    
    // rosterView
    
    self.rosterView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // self.rosterView.frame = CGRectMake(2 * self.frame.size.width / 3, self.frame.size.width / 1.9, self.frame.size.width / 3, self.frame.size.width / 1.7);
        [self.rosterView addTarget:self action:@selector(rosterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *fullRosterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.athlete1View.frame.size.height / 2 + 10, self.frame.size.width - 20, 15)];
    UILabel *fullRosterLabel = [UILabel new];
    fullRosterLabel.textAlignment = NSTextAlignmentCenter;
    fullRosterLabel.text = @"Full Roster";
    fullRosterLabel.font = [UIFont systemFontOfSize:13];
    [self.rosterView addSubview:fullRosterLabel];
    [self addSubview:self.rosterView];
    [fullRosterLabel alignLeading:@"0" trailing:@"0" toView:self.rosterView];
    [fullRosterLabel alignCenterYWithView:self.rosterView predicate:@"0"];
    
    
//    [self.athlete1View alignTop:@"0" leading:@"0" toView:self];
//    [self.athlete1View constrainHeightToView:self predicate:@"*.5"];
//    [self.athlete1View constrainWidthToView:self predicate:@"*.3333333"];
//    [self.athlete2View alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeTrailing ofView:self.athlete1View predicate:@"0"];
//    [self.athlete3View alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeTrailing ofView:self.athlete2View predicate:@"0"];
//    [self.athlete3View alignTrailingEdgeWithView:self predicate:@"0"];
//    [self.athlete5View alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeTrailing ofView:self.athlete4View predicate:@"0"];
//    [self.rosterView alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeTrailing ofView:self.athlete5View predicate:@"0"];
//    [self.rosterView alignTrailingEdgeWithView:self predicate:@"0"];
//    [self.athlete2View alignCenterXWithView:self predicate:@"0"];
//    [self.athlete4View alignAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofView:self.athlete1View predicate:@"0"];
//    [self.athlete4View alignLeadingEdgeWithView:self predicate:@"0"];
//    [UIView alignTopAndBottomEdgesOfViews:@[self.athlete1View, self.athlete2View, self.athlete3View]];
//    [UIView alignTopAndBottomEdgesOfViews:@[self.athlete4View, self.athlete5View, self.rosterView]];
//    [UIView equalHeightForViews:@[self.athlete1View, self.athlete2View, self.athlete3View, self.athlete4View, self.athlete5View, self.rosterView]];
//    [UIView equalWidthForViews:@[self.athlete1View, self.athlete2View, self.athlete3View, self.athlete4View, self.athlete5View, self.rosterView]];
     
    
    
    [self.athlete1View alignTop:@"0" leading:@"0" toView:self.contentView];
    [self.athlete1View constrainHeightToView:self.contentView predicate:@"*.5"];
//    [self.athlete1View constrainWidthToView:self.contentView predicate:@"*.33"];
    
    [self.athlete2View alignTopEdgeWithView:self.athlete1View predicate:@"0"];
    [self.athlete2View constrainLeadingSpaceToView:self.athlete1View predicate:@"0"];
    [self.athlete2View constrainHeightToView:self.contentView predicate:@"*.5"];
//    [self.athlete2View constrainWidthToView:self.contentView predicate:@"*.33"];
    
    [self.athlete3View alignTopEdgeWithView:self.athlete1View predicate:@"0"];
    [self.athlete3View constrainLeadingSpaceToView:self.athlete2View predicate:@"0"];
    [self.athlete3View alignTrailingEdgeWithView:self.contentView predicate:@"0"];
    [self.athlete3View constrainHeightToView:self.contentView predicate:@"*.5"];
//    [self.athlete3View constrainWidthToView:self.contentView predicate:@"*.34"];
    
    [self.athlete4View alignBottomEdgeWithView:self.contentView predicate:@"0"];
    [self.athlete4View constrainTopSpaceToView:self.athlete1View predicate:@"0"];
    [self.athlete4View alignLeadingEdgeWithView:self.contentView predicate:@"0"];
    [self.athlete4View constrainHeightToView:self.contentView predicate:@"*.5"];
    
    [self.athlete5View alignBottomEdgeWithView:self.contentView predicate:@"0"];
    [self.athlete5View constrainTopSpaceToView:self.athlete2View predicate:@"0"];
    [self.athlete5View constrainLeadingSpaceToView:self.athlete4View predicate:@"0"];
    [self.athlete5View constrainHeightToView:self.contentView predicate:@"*.5"];
    
    [self.rosterView alignBottomEdgeWithView:self.contentView predicate:@"0"];
    [self.rosterView constrainLeadingSpaceToView:self.athlete5View predicate:@"0"];
    [self.rosterView constrainTopSpaceToView:self.athlete3View predicate:@"0"];
    [self.rosterView constrainHeightToView:self.contentView predicate:@"*.5"];
    [self.rosterView alignTrailingEdgeWithView:self.contentView predicate:@"0"];
    
    [UIView equalHeightForViews:@[self.athlete1View, self.athlete2View, self.athlete3View, self.athlete4View, self.athlete5View, self.rosterView]];
    [UIView equalWidthForViews:@[self.athlete1View, self.athlete2View, self.athlete3View, self.athlete4View, self.athlete5View, self.rosterView]];

}

- (void)loadDataWithAthletes:(NSArray *)athletes {
    self.mostViewedAthletes = athletes;
    Athlete *athlete1 = athletes[0];
    Athlete *athlete2 = athletes[1];
    Athlete *athlete3 = athletes[2];
    Athlete *athlete4 = athletes[3];
    Athlete *athlete5 = athletes[4];
    
    self.athlete1ImageView.image = athlete1.photo;
    self.athlete1NameLabel.text = athlete1.name;
    //self.athlete1View.tag = 0;
    
    self.athlete2ImageView.image = athlete2.photo;
    self.athlete2NameLabel.text = athlete2.name;
    //self.athlete2View.tag = 1;
    
    self.athlete3ImageView.image = athlete3.photo;
    self.athlete3NameLabel.text = athlete3.name;
    //self.athlete3View.tag = 2;
    
    self.athlete4ImageView.image = athlete4.photo;
    self.athlete4NameLabel.text = athlete4.name;
    //self.athlete4View.tag = 3;
    
    self.athlete5ImageView.image = athlete5.photo;
    self.athlete5NameLabel.text = athlete5.name;
    
  
    //self.athlete4View.tag = 4;
}

- (void)buttonPressed:(UIButton *)sender{
    if (sender.touchInside == YES) {
        [self.delegate athleteButtonPressed:self.mostViewedAthletes[(int)sender.tag]];
    }
}

- (void)rosterButtonPressed{
    [self.delegate rosterButtonPressed];
}

@end