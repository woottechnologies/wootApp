//
//  EditDataSource.h
//  wootApp
//
//  Created by Cole Wilkes on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditUserViewController.h"
@import UIKit;

@interface EditDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(EditUserViewController *)viewController;

@end
