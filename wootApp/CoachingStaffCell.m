//
//  CoachingStaffCell.m
//  wootApp
//
//  Created by Cole Wilkes on 6/29/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CoachingStaffCell.h"
#import "UIView+FLKAutoLayout.h"
#import "TeamController.h"

@interface CoachingStaffCell()

@property (nonatomic, strong) UIImageView *headCoachImageView;
@property (nonatomic, strong) UILabel *headCoachLabel;

@property (nonatomic, strong) UIImageView *coachingStaffImageView;
@property (nonatomic, strong) UILabel *coachingStaffLabel;

@end

@implementation CoachingStaffCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupCell];
    }
    
    return self;
}

- (void)setupCell {
    // head coach
    self.headCoachView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.headCoachView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.headCoachImageView = [[UIImageView alloc] init];
    self.headCoachLabel = [[UILabel alloc] init];
    self.headCoachLabel.textAlignment = NSTextAlignmentCenter;
    self.headCoachLabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:self.headCoachView];
    [self.headCoachView alignTop:@"0" bottom:@"0" toView:self.contentView];
    [self.headCoachView alignLeadingEdgeWithView:self.contentView predicate:@"0"];
    [self.headCoachView constrainHeightToView:self.contentView predicate:@"0"];
    [self.headCoachView constrainAspectRatio:@"*0.7"];
    
    [self.headCoachView addSubview:self.headCoachImageView];
    [self.headCoachView addSubview:self.headCoachLabel];
    [self.headCoachImageView alignTop:@"0" leading:@"0" toView:self.headCoachView];
    [self.headCoachImageView alignTrailingEdgeWithView:self.headCoachView predicate:@"0"];
    [self.headCoachImageView constrainHeightToView:self.headCoachView predicate:@"-15"];
    [self.headCoachLabel alignLeading:@"0" trailing:@"0" toView:self.headCoachView];
    [self.headCoachLabel constrainTopSpaceToView:self.headCoachImageView predicate:@"0"];
    [self.headCoachLabel constrainHeight:@"15"];
    
    // coaching staff
    self.coachingStaffView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.coachingStaffView.backgroundColor = [UIColor redColor];
    [self.coachingStaffView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.coachingStaffImageView = [[UIImageView alloc] init];
    self.coachingStaffLabel = [[UILabel alloc] init];
    self.coachingStaffLabel.textAlignment = NSTextAlignmentCenter;
    self.coachingStaffLabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:self.coachingStaffView];
    [self.coachingStaffView constrainLeadingSpaceToView:self.headCoachView predicate:@"0"];
    [self.coachingStaffView alignTrailingEdgeWithView:self.contentView predicate:@"0"];
    [self.coachingStaffView alignTop:@"0" bottom:@"0" toView:self.contentView];
    [self.coachingStaffView addSubview:self.coachingStaffImageView];
    [self.coachingStaffView addSubview:self.coachingStaffLabel];
    [self.coachingStaffImageView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.coachingStaffView];
    
    [self.coachingStaffImageView constrainHeightToView:self.coachingStaffView predicate:@"0"];
//    [self.coachingStaffLabel alignLeading:@"0" trailing:@"0" toView:self.coachingStaffView];
//    [self.coachingStaffLabel constrainTopSpaceToView:self.coachingStaffView predicate:@"0"];
//    [self.coachingStaffLabel constrainHeight:@"15"];
}

- (void)finishCell {
    for (Coach *coach in [TeamController sharedInstance].currentTeam.coaches) {
        if ([coach.title isEqualToString:@"Head Coach"]) {
            self.headCoachImageView.image = coach.photo;
            self.headCoachLabel.text = coach.name;
        }
    }
    
    self.coachingStaffImageView.image = [TeamController sharedInstance].currentTeam.coachingStaffPhoto;
}

- (void)buttonPressed:(id)button {
    [self.delegate coachButtonPressed];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
