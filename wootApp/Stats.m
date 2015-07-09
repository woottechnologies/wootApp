//
//  Stats.m
//  wootApp
//
//  Created by Egan Anderson on 6/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Stats.h"
#import "TeamController.h"
#import "AthleteController.h"

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
        self.receivingTD = [dictionary[@"receivingTD"] floatValue];
        self.rushingTD = [dictionary[@"rushingTD"] floatValue];
        self.conversions = [dictionary[@"conversions"] floatValue];
        self.fieldGoals = [dictionary[@"fieldGoals"] floatValue];
        self.fieldGoalYards = [dictionary[@"fieldGoalYards"] floatValue];
        self.fieldGoalLong = [dictionary[@"fieldGoalLong"] floatValue];
        self.pat = [dictionary[@"pat"] floatValue];
        self.tackles = [dictionary[@"tackles"] floatValue];
        self.sacks = [dictionary[@"sacks"] floatValue];
        self.tfl = [dictionary[@"tfl"] floatValue];
        self.completePasses = [dictionary[@"completePasses"] floatValue];
        self.completePassYards = [dictionary[@"completePassYards"] floatValue];
        self.touchdownPasses = [dictionary[@"touchDownPasses"] floatValue];
        self.completePassLong = [dictionary[@"completePassLong"] floatValue];
        self.incompletePasses = [dictionary[@"incompletePasses"] floatValue];
        self.interceptedPasses = [dictionary[@"interceptedPasses"] floatValue];
        self.interceptions = [dictionary[@"interceptions"] floatValue];
        self.receptions = [dictionary[@"receptions"] floatValue];
        self.receivingYards = [dictionary[@"receivingYards"] floatValue];
        self.receivingLong = [dictionary[@"receivingLong"] floatValue];
        self.carries = [dictionary[@"carries"] floatValue];
        self.rushingYards = [dictionary[@"rushingYards"] floatValue];
        self.punts = [dictionary[@"puntYards"] floatValue];
        self.puntsInTwenty = [dictionary[@"puntsInTwenty"] floatValue];
        self.kickOffs = [dictionary[@"kickOffs"] floatValue];
        self.kickOffYards = [dictionary[@"kickOffYards"] floatValue];
        self.gamesPlayed = [dictionary[@"gamesPlayed"] floatValue];
    }
    return self;
}

- (NSDictionary *)summaryStats{
    Athlete *athlete = [AthleteController sharedInstance].currentAthlete;
    switch (athlete.statType) {
        case QB:
            if(self.gamesPlayed == 0 || !self.gamesPlayed){
                return @{@"Yds" : @"0", @"Cmp" : @"0", @"TD Passes" : @"0", @"Int" : @"0", @"Y/G" : @"0", @"Y/Cmp" : @"0", @"Stat Names" : @[@"Yds", @"Cmp", @"TD Passes", @"Int", @"Y/G", @"Y/Cmp"]};
            } else if(self.completePasses == 0 || !self.completePasses){
                return @{@"Yds" : @"0", @"Cmp" : @"0", @"TD Passes" : @"0", @"Int" : [NSString stringWithFormat:@"%.f", self.interceptedPasses], @"Y/G" : @"0", @"Y/Cmp" : @"0", @"Stat Names" : @[@"Yds", @"Cmp", @"TD Passes", @"Int", @"Y/G", @"Y/Cmp"]};
            } else {
                return @{@"Yds" : [NSString stringWithFormat:@"%.f", self.completePassYards], @"Cmp" : [NSString stringWithFormat:@"%.f", self.completePasses], @"TD Passes" : [NSString stringWithFormat:@"%.f", self.touchdownPasses], @"Int" : [NSString stringWithFormat:@"%.f", self.interceptedPasses], @"Y/G" : [NSString stringWithFormat:@"%.1f", self.completePassYards/self.gamesPlayed], @"Y/Cmp" : [NSString stringWithFormat:@"%.1f", self.completePassYards/self.completePasses], @"Stat Names" : @[@"Yds", @"Cmp", @"TD Passes", @"Int", @"Y/G", @"Y/Cmp"]};
            }
            break;
        case Receiving:
            if(self.gamesPlayed == 0 || !self.gamesPlayed || self.receptions == 0 || !self.receptions){
                return @{@"Rec" : @"0", @"Yds" : @"0", @"TD" : @"0", @"Y/Rec" : @"0", @"Y/G" : @"0", @"Lng" : @"0", @"Stat Names" : @[@"Rec", @"Yds", @"TD", @"Y/Rec", @"Y/G", @"Lng"]};
            } else {
                return @{@"Rec" : [NSString stringWithFormat:@"%.f", self.receptions], @"Yds" : [NSString stringWithFormat:@"%.f", self.receivingYards], @"TD" : [NSString stringWithFormat:@"%.f", self.receivingTD], @"Y/Rec" : [NSString stringWithFormat:@"%.1f", self.receivingYards/self.receptions], @"Y/G" : [NSString stringWithFormat:@"%.1f", self.receivingYards/self.gamesPlayed], @"Lng" : [NSString stringWithFormat:@"%.f", self.receivingLong], @"Stat Names" : @[@"Rec", @"Yds", @"TD", @"Y/Rec", @"Y/G", @"Lng"]};
            }
            break;
        case Rushing:
            if(self.gamesPlayed == 0 || !self.gamesPlayed || self.carries == 0 || !self.carries){
                return @{@"Car" : @"0", @"Yds" : @"0", @"TD" : @"0", @"Y/Car" : @"0", @"Y/G" : @"0", @"100+" : @"0", @"Stat Names" : @[@"Car", @"Yds", @"TD", @"Y/Car", @"Y/G", @"100+"]};
            } else {
                return @{@"Car" : [NSString stringWithFormat:@"%.f", self.carries], @"Yds" : [NSString stringWithFormat:@"%.f", self.rushingYards], @"TD" : [NSString stringWithFormat:@"%.f", self.rushingTD], @"Y/Car" : [NSString stringWithFormat:@"%.1f", self.rushingYards/self.carries], @"Y/G" : [NSString stringWithFormat:@"%.1f", self.rushingYards/self.gamesPlayed], @"100+" : [NSString stringWithFormat:@"%.f", 4.0], @"Stat Names" : @[@"Car", @"Yds", @"TD", @"Y/Car", @"Y/G", @"100+"]};
            }
            break;
        case Kicker:
            if(self.fieldGoals == 0 || !self.fieldGoals){
                return @{@"FG" : @"0", @"FG %" : @"0", @"FG Lng" : @"0", @"PAT" : [NSString stringWithFormat:@"%.f", self.pat], @"PAT %" : [NSString stringWithFormat:@"%.2f", 0.878], @"KO Yds" : [NSString stringWithFormat:@"%.f", self.kickOffYards], @"Stat Names" : @[@"FG", @"FG%", @"FG Lng", @"KO Yds", @"PAT", @"PAT %"]};
            } else if(self.pat == 0 || !self.pat){
                return @{@"FG" : @(self.fieldGoals), @"FG %" : [NSString stringWithFormat:@"%.2f", 0.711], @"FG Lng" : [NSString stringWithFormat:@"%.f", self.fieldGoalLong], @"PAT" : @"0", @"PAT %" : @"0", @"KO Yds" : [NSString stringWithFormat:@"%.f", self.kickOffYards], @"Stat Names" : @[@"FG", @"FG%", @"FG Lng", @"KO Yds", @"PAT", @"PAT %"]};
            } else {
                return @{@"FG" : [NSString stringWithFormat:@"%.f", self.fieldGoals], @"FG %" : [NSString stringWithFormat:@"%.2f", 0.7112], @"FG Lng" : [NSString stringWithFormat:@"%.f", self.fieldGoalLong], @"PAT" : [NSString stringWithFormat:@"%.f", self.pat], @"PAT %" : [NSString stringWithFormat:@"%.2f", 0.878], @"KO Yds" : [NSString stringWithFormat:@"%.f", self.kickOffYards], @"Stat Names" : @[@"FG", @"FG %", @"FG Lng", @"KO Yds", @"PAT", @"PAT %"]};
            }
            break;
        case Punter:
            if(self.gamesPlayed == 0 || !self.gamesPlayed || self.punts == 0 || !self.punts){
                return @{@"P" : @"0", @"Yds" : @"0", @"Yds/P" : @"0", @"Lng" : @"0", @"In 20" : @"0", @"P/G" : @"0", @"Stat Names" : @[@"P", @"P/G", @"Yds", @"Yds/P", @"Lng", @"In 20"]};
            } else {
                return @{@"P" : [NSString stringWithFormat:@"%.f", self.punts], @"Yds" : [NSString stringWithFormat:@"%.f", self.puntYards], @"Yds/P" : [NSString stringWithFormat:@"%.1f", self.puntYards/self.punts], @"Lng" : [NSString stringWithFormat:@"%.f", 44.0], @"In 20" : [NSString stringWithFormat:@"%.f", self.puntsInTwenty], @"P/G" : [NSString stringWithFormat:@"%.1f", self.punts/self.gamesPlayed], @"Stat Names" : @[@"P", @"P/G", @"Yds", @"Yds/P", @"Lng", @"In 20"]};
            }
            break;
        case Defense:
            if(self.gamesPlayed == 0 || !self.gamesPlayed){
                return @{@"Tckl" : @"0", @"Sak" : @"0", @"Int" : @"0", @"Tckl/G" : @"0", @"TFL" : @"0", @"Sak/G" : @"0", @"Stat Names" : @[@"Tckl", @"Tckl/G", @"Sak", @"Sak/G", @"Int", @"TFL"]};
            } else {
                return @{@"Tckl" : [NSString stringWithFormat:@"%.f", self.tackles], @"Sak" : [NSString stringWithFormat:@"%.f", self.sacks], @"Int" : [NSString stringWithFormat:@"%.f", self.interceptions], @"Tckl/G" : [NSString stringWithFormat:@"%.1f", self.tackles/self.gamesPlayed], @"TFL" : [NSString stringWithFormat:@"%.f", self.tfl], @"Sak/G" : [NSString stringWithFormat:@"%.1f", self.sacks/self.gamesPlayed], @"Stat Names" : @[@"Tckl", @"Tckl/G", @"Sak", @"Sak/G", @"Int", @"TFL"]};
            }
            break;
        default:
            return nil;
            break;
    }
}

@end
