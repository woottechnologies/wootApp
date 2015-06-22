//
//  Stats.m
//  wootApp
//
//  Created by Egan Anderson on 6/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Stats.h"
#import "TeamController.h"

typedef NS_ENUM(int16_t, summaryStatsType){
    QB = 1,
    Receiving = 2,
    Rushing = 3,
    Kicker = 4,
    Punter = 5,
    Defense = 6,
    None = 7
};

@implementation Stats

- (instancetype)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.receivingTD = [dictionary[@"receivingTD"] integerValue];
        self.rushingTD = [dictionary[@"rushingTD"] integerValue];
        self.conversions = [dictionary[@"conversions"] integerValue];
        self.fieldGoals = [dictionary[@"fieldGoals"] integerValue];
        self.fieldGoalYards = [dictionary[@"fieldGoalYards"] integerValue];
        self.fieldGoalLong = [dictionary[@"fieldGoalLong"] integerValue];
        self.pat = [dictionary[@"pat"] integerValue];
        self.tackles = [dictionary[@"tackles"] integerValue];
        self.sacks = [dictionary[@"sacks"] integerValue];
        self.tfl = [dictionary[@"tfl"] integerValue];
        self.completePasses = [dictionary[@"completePasses"] integerValue];
        self.completePassYards = [dictionary[@"completePassYards"] integerValue];
        self.touchdownPasses = [dictionary[@"touchDownPasses"] integerValue];
        self.completePassLong = [dictionary[@"completePassLong"] integerValue];
        self.incompletePasses = [dictionary[@"incompletePasses"] integerValue];
        self.interceptedPasses = [dictionary[@"interceptedPasses"] integerValue];
        self.interceptions = [dictionary[@"interceptions"] integerValue];
        self.receptions = [dictionary[@"receptions"] integerValue];
        self.receivingYards = [dictionary[@"receivingYards"] integerValue];
        self.receivingLong = [dictionary[@"receivingLong"] integerValue];
        self.carries = [dictionary[@"carries"] integerValue];
        self.rushingYards = [dictionary[@"rushingYards"] integerValue];
        self.punts = [dictionary[@"puntYards"] integerValue];
        self.puntsInTwenty = [dictionary[@"puntsInTwenty"] integerValue];
        self.kickOffs = [dictionary[@"kickOffs"] integerValue];
        self.kickOffYards = [dictionary[@"kickOffYards"] integerValue];
        self.gamesPlayed = [dictionary[@"gamesPlayed"] integerValue];
    }
    return self;
}

- (NSDictionary *)summaryStats{
    Athlete *athlete = [TeamController sharedInstance].currentAthlete;
    switch (athlete.statType) {
        case QB:
            return @{@"Yds" : @(self.completePassYards), @"Cmp" : @(self.completePasses), @"TD Passes" : @(self.touchdownPasses), @"Int" : @(self.interceptedPasses), @"Y/G" : @(self.completePassYards/self.gamesPlayed), @"Y/Cmp" : @(self.completePassYards/self.completePasses)};
            break;
        case Receiving:
            return @{@"Rec" : @(self.receptions), @"Yds" : @(self.receivingYards), @"TD" : @(self.receivingTD), @"Y/Rec" : @(self.receivingYards/self.receptions), @"Y/G" : @(self.receivingYards/self.gamesPlayed), @"Lng" : @(self.receivingLong)};
            break;
        case Rushing:
            return @{@"Car" : @(self.carries), @"Yds" : @(self.rushingYards), @"TD" : @(self.rushingTD), @"Y/Car" : @(self.rushingYards/self.carries), @"Y/G" : @(self.rushingYards/self.carries), @"100+" : @4};
            break;
        case Kicker:
            return @{@"FG" : @(self.fieldGoals), @"FG %" : @(0.711), @"FG long" : @(self.fieldGoalLong), @"PAT" : @(self.pat), @"PAT %" : @(0.878), @"KO Yds" : @(self.kickOffYards)};
            break;
        case Punter:
            return @{@"P" : @(self.punts), @"Yds" : @(self.puntYards), @"Yds/P" : @(self.puntYards/self.punts), @"Lng" : @(44), @"In 20" : @(self.puntsInTwenty), @"P/G" : @(self.punts/self.gamesPlayed)};
            break;
        case Defense:
            return @{@"Tckl" : @(self.tackles), @"Sak" : @(self.sacks), @"Int" : @(self.interceptions), @"Tckl/G" : @(self.tackles/self.gamesPlayed), @"TFL" : @(self.tfl), @"Sak/G" : @(self.sacks/self.gamesPlayed)};
            break;
        default:
            return nil;
            break;
    }
}

@end
