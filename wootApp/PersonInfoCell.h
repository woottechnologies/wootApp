//
//  PersonInfoCell.h
//  wootApp
//
//  Created by Egan Anderson on 8/19/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *infoTypeLabel;
@property (nonatomic, strong) UILabel *infoValueLabel;

- (instancetype)initWithInfoType:(NSString *)infoType infoValue:(NSString *)infoValue style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setUpCellWithInfoType:(NSString *)infoType infoValue:(NSString *)infoValue;

@end
