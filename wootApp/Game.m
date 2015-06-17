//
//  Game.m
//  wootApp
//
//  Created by Cole Wilkes on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Game.h"
#import "TeamController.h"

@interface Game()

@property (nonatomic, assign) NSInteger homeTeamScore;
@property (nonatomic, assign) NSInteger awayTeamScore;

@end

@implementation Game

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.gameID = [dictionary[GameIDKey] integerValue];
        self.date = dictionary[DateKey];
        self.homeTeamID = [dictionary[HomeTeamKey] integerValue];
        self.awayTeamID = [dictionary[AwayTeamKey] integerValue];
        self.homeTeamScore = [dictionary[HomeScoreKey] integerValue];
        self.awayTeamScore = [dictionary[AwayScoreKey] integerValue];
        self.opposingSchool = dictionary[OpposingSchoolKey];
    }
    
    return self;
}

- (NSString *)currentScore {
    NSString *scoreString = [NSString stringWithFormat:@"%li - %li", self.homeTeamScore, self.awayTeamScore];
    return scoreString;
}

- (NSString *)finalScore {
    if (self.homeTeamScore > self.awayTeamScore) {
        return [NSString stringWithFormat:@"%li - %li", self.homeTeamScore, self.awayTeamScore];
    }
    
    return [NSString stringWithFormat:@"%li - %li", self.awayTeamScore, self.homeTeamScore];
}

- (Team *)winningTeam {
    if (self.isOver && self.homeTeamScore > self.awayTeamScore) {
        return self.homeTeam;
    } else if (self.isOver && self.awayTeamScore > self.homeTeamScore) {
        return self.awayTeam;
    } else {
        return nil;
    }
}

@end
