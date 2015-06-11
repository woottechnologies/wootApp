//
//  Game.h
//  wootApp
//
//  Created by Cole Wilkes on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

static NSString *GameIDKey = @"id";
static NSString *DateKey = @"date";
static NSString *HomeTeamKey = @"homeTeam";
static NSString *AwayTeamKey = @"awayTeam";
static NSString *HomeScoreKey = @"homeScore";
static NSString *AwayScoreKey = @"awayScore";

@interface Game : NSObject

@property (nonatomic, assign) NSInteger gameID;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) Team *homeTeam;
@property (nonatomic, strong) Team *awayTeam;
@property (nonatomic, strong) NSString *currentScore;
@property (nonatomic, strong) NSString *finalScore;
@property (nonatomic, strong) Team *winningTeam;
@property (nonatomic) BOOL isOver;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
