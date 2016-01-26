//
//  OriginalContentCell.h
//  wootApp
//
//  Created by Egan Anderson on 1/18/16.
//  Copyright © 2016 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeFeedCellDelegate;

@interface OriginalContentCell : UITableViewCell

@property (weak, nonatomic) id<HomeFeedCellDelegate> delegate;

- (void)setUpOriginalContentCell:(NSDictionary *)contents;

@end
