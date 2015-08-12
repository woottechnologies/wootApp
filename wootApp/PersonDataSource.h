//
//  PersonDataSource.h
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@class PersonViewController;

@interface PersonDataSource : NSObject <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView viewController:(PersonViewController *)viewController;

@end
