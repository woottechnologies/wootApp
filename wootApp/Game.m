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
@property (nonatomic, strong) NSString *dateFromDB;

@end

@implementation Game

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.gameID = [dictionary[GameIDKey] integerValue];
        self.dateFromDB = dictionary[DateKey];
        self.homeTeamID = [dictionary[HomeTeamKey] integerValue];
        self.awayTeamID = [dictionary[AwayTeamKey] integerValue];
        self.homeTeamScore = [dictionary[HomeScoreKey] integerValue];
        self.awayTeamScore = [dictionary[AwayScoreKey] integerValue];
        self.opposingSchool = dictionary[OpposingSchoolKey];
        
        if([dictionary[IsOverKey] isEqualToString:@"Y"]) {
            self.isOver = YES;
        } else {
            self.isOver = NO;
        }
    }
    
    return self;
}


- (NSString *)currentScore {
    NSString *scoreString = [NSString stringWithFormat:@"%li - %li", self.homeTeamScore, self.awayTeamScore];
    return scoreString;
}

- (NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:self.dateFromDB];
}

- (NSString *)finalScore {
    if (self.homeTeamScore > self.awayTeamScore) {
        return [NSString stringWithFormat:@"%li - %li", self.homeTeamScore, self.awayTeamScore];
    }
    
    return [NSString stringWithFormat:@"%li - %li", self.awayTeamScore, self.homeTeamScore];
}

- (NSInteger)winningTeamID {
    if (self.isOver && self.homeTeamScore > self.awayTeamScore) {
        return self.homeTeamID;
    } else if (self.isOver && self.awayTeamScore > self.homeTeamScore) {
        return self.awayTeamID;
    } else {
        return -1;
    }
}

- (NSString *)dateString {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormat dateFromString:self.dateFromDB];
    [dateFormat setDateFormat:@"MMM dd"];
    return [dateFormat stringFromDate:date];
    
    }

@end
