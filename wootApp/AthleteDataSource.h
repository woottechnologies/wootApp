//
//  AthleteDataSource.h
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AthleteViewController.h"
@import UIKit;

@interface AthleteDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(AthleteViewController *)viewController;

@end
