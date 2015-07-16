//
//  HomeFeedDataSource.h
//  wootApp
//
//  Created by Egan Anderson on 7/14/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>
#import "HomeFeedViewController.h"

@interface HomeFeedDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(HomeFeedViewController *)viewController;

@end
