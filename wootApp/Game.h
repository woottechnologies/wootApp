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
static NSString *HomeTeamKey = @"homeTeamID";
static NSString *AwayTeamKey = @"awayTeamID";
static NSString *HomeScoreKey = @"homeScore";
static NSString *AwayScoreKey = @"awayScore";
static NSString *OpposingSchoolKey = @"opposingSchool";
static NSString *OpposingLogoKey = @"opposingLogo";
static NSString *IsOverKey = @"isOver";

@interface Game : NSObject

@property (nonatomic, assign) NSInteger gameID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, assign) NSInteger homeTeamID;
@property (nonatomic, assign) NSInteger awayTeamID;
@property (nonatomic, strong) NSString *opposingSchool;
@property (nonatomic, strong) UIImage *opposingLogo;
@property (nonatomic, strong) NSString *currentScore;
//@property (nonatomic, strong) NSString *finalScore;
@property (nonatomic, assign) NSInteger winningTeamID;
//@property (nonatomic, strong) Team *homeTeam;
//@property (nonatomic, strong) Team *awayTeam;
@property (nonatomic) BOOL isOver;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
