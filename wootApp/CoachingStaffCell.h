//
//  CoachingStaffCell.h
//  wootApp
//
//  Created by Cole Wilkes on 6/29/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoachingStaffCellDelegate;

@interface CoachingStaffCell : UITableViewCell

@property (nonatomic, strong) UIButton *headCoachView;
@property (nonatomic, strong) UIButton *coachingStaffView;
@property (weak, nonatomic) id<CoachingStaffCellDelegate> delegate;

- (void)finishCell;

@end

@protocol CoachingStaffCellDelegate <NSObject>

- (void)coachButtonPressed;

@end
