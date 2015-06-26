//
//  MostViewedPlayersTableViewCell.h
//  wootApp
//
//  Created by Egan Anderson on 6/4/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"

@protocol MostViewedPlayerTableViewCellDelegate;

@interface MostViewedPlayersTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *athlete1View;
@property (nonatomic, strong) UIButton *athlete2View;
@property (nonatomic, strong) UIButton *athlete3View;
@property (nonatomic, strong) UIButton *athlete4View;
@property (nonatomic, strong) UIButton *athlete5View;
@property (nonatomic, strong) UIButton *athlete6View;
@property (nonatomic, strong) UIButton *rosterView;

@property (weak, nonatomic) id<MostViewedPlayerTableViewCellDelegate> delegate;

- (void)loadDataWithAthletes:(NSArray *)athletes;

@end

@protocol MostViewedPlayerTableViewCellDelegate <NSObject>

- (void)athleteButtonPressed:(Athlete *)athlete;

- (void)rosterButtonPressed;

@end


