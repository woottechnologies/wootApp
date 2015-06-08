//
//  TeamDataSource.h
//  wootApp
//
//  Created by Egan Anderson on 6/4/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MostViewedPlayersTableViewCell.h"

@import UIKit;
@class TeamViewController;

@interface TeamDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(TeamViewController *)viewController;

@end
