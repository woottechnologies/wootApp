//
//  TeamViewController.h
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SchoolListViewController.h"
#import "MostViewedPlayersTableViewCell.h"
#import "CoachingStaffCell.h"

@interface TeamViewController : UIViewController <MostViewedPlayerTableViewCellDelegate, CoachingStaffCellDelegate>

- (void)unhideToolBar;

@end
