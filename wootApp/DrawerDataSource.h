//
//  DrawerDataSource.h
//  wootApp
//
//  Created by Cole Wilkes on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTabBarVC.h"
@import UIKit;

@interface DrawerDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(CustomTabBarVC *)viewController;

@end
