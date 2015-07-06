//
//  SchoolListTableViewCell.h
//  wootApp
//
//  Created by Egan Anderson on 7/2/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "School.h"

@interface SchoolListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cellImage;

- (void)setUpCell:(School *) school;

@end
