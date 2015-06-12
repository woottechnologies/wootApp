//
//  RosterTableViewCell.h
//  wootApp
//
//  Created by Egan Anderson on 6/12/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamController.h"

@interface RosterTableViewCell : UITableViewCell

- (instancetype)initWithAthlete:(Athlete *)athlete style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
