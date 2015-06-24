//
//  Stats.h
//  wootApp
//
//  Created by Egan Anderson on 6/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property (nonatomic, assign) float receivingTD;
@property (nonatomic, assign) float rushingTD;
@property (nonatomic, assign) float conversions;
@property (nonatomic, assign) float fieldGoals;
@property (nonatomic, assign) float fieldGoalYards;
@property (nonatomic, assign) float fieldGoalLong;
@property (nonatomic, assign) float pat;
@property (nonatomic, assign) float tackles;
@property (nonatomic, assign) float sacks;
@property (nonatomic, assign) float tfl;
@property (nonatomic, assign) float completePasses;
@property (nonatomic, assign) float completePassYards;
@property (nonatomic, assign) float touchdownPasses;
@property (nonatomic, assign) float completePassLong;
@property (nonatomic, assign) float incompletePasses;
@property (nonatomic, assign) float interceptedPasses;
@property (nonatomic, assign) float interceptions;
@property (nonatomic, assign) float receptions;
@property (nonatomic, assign) float receivingYards;
@property (nonatomic, assign) float receivingLong;
@property (nonatomic, assign) float carries;
@property (nonatomic, assign) float rushingYards;
@property (nonatomic, assign) float punts;
@property (nonatomic, assign) float puntYards;
@property (nonatomic, assign) float puntsInTwenty;
@property (nonatomic, assign) float kickOffs;
@property (nonatomic, assign) float kickOffYards;
@property (nonatomic, assign) float gamesPlayed;
@property (nonatomic, strong) NSDictionary *summaryStats;

- (instancetype)initWithDictionary: (NSDictionary *)dictionary;

- (NSDictionary *)summaryStats;

@end
