//
//  SummaryStatsTableViewCell.h
//  wootApp
//
//  Created by Egan Anderson on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryStatsTableViewCell : UITableViewCell

- (void)loadDataWithStats:(NSDictionary *)summaryStats;

@end
