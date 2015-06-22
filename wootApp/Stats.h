//
//  Stats.h
//  wootApp
//
//  Created by Egan Anderson on 6/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property (nonatomic, assign) NSInteger receivingTD;
@property (nonatomic, assign) NSInteger rushingTD;
@property (nonatomic, assign) NSInteger conversions;
@property (nonatomic, assign) NSInteger fieldGoals;
@property (nonatomic, assign) NSInteger fieldGoalYards;
@property (nonatomic, assign) NSInteger fieldGoalLong;
@property (nonatomic, assign) NSInteger pat;
@property (nonatomic, assign) NSInteger tackles;
@property (nonatomic, assign) NSInteger sacks;
@property (nonatomic, assign) NSInteger tfl;
@property (nonatomic, assign) NSInteger completePasses;
@property (nonatomic, assign) NSInteger completePassYards;
@property (nonatomic, assign) NSInteger touchdownPasses;
@property (nonatomic, assign) NSInteger completePassLong;
@property (nonatomic, assign) NSInteger incompletePasses;
@property (nonatomic, assign) NSInteger interceptedPasses;
@property (nonatomic, assign) NSInteger interceptions;
@property (nonatomic, assign) NSInteger receptions;
@property (nonatomic, assign) NSInteger receivingYards;
@property (nonatomic, assign) NSInteger receivingLong;
@property (nonatomic, assign) NSInteger carries;
@property (nonatomic, assign) NSInteger rushingYards;
@property (nonatomic, assign) NSInteger punts;
@property (nonatomic, assign) NSInteger puntYards;
@property (nonatomic, assign) NSInteger puntsInTwenty;
@property (nonatomic, assign) NSInteger kickOffs;
@property (nonatomic, assign) NSInteger kickOffYards;
@property (nonatomic, assign) NSInteger gamesPlayed;
@property (nonatomic, strong) NSDictionary *summaryStats;

- (instancetype)initWithDictionary: (NSDictionary *)dictionary;

- (NSDictionary *)summaryStats;

@end
