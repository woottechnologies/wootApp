//
//  PersonInfoDataSource.h
//  wootApp
//
//  Created by Egan Anderson on 8/19/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@class PersonViewController;

@interface PersonInfoDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(PersonViewController *)viewController;

@end
