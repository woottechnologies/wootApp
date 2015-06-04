//
//  TeamController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamController.h"
#import "Athlete.h"

@interface TeamController()

@property (nonatomic, strong) NSArray *teams;

@end

@implementation TeamController

+ (instancetype)sharedInstance {
    static TeamController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TeamController alloc] init];
        [sharedInstance loadTeams];
    });
    
    return sharedInstance;
}

- (void)loadTeams {
    self.teams = [[NSArray alloc]init];
    NSDictionary *wxFBTeamDict = @{TeamIDKey:@1,
                                   SchoolIDKey:@1,
                                   TypeKey:@"Football",
                                   WinsKey:@4,
                                   LossesKey:@1};
    
    NSMutableArray *teamsMutable = [[NSMutableArray alloc] init];
    Team *wxFootball = [[Team alloc] initWithDictionary:wxFBTeamDict];
    
    [teamsMutable addObject:wxFootball];
    
    self.teams = teamsMutable;
    [self loadAthletes];
}

- (void)loadAthletes {
    
    
     NSDictionary *athlete1 = @{AthleteIDKey:@1,
     NameKey:@"Thomas Moore",
     JerseyNumberKey:@23,
     PhotoKey:@"thomas_moore",
     PositionKey:@"RB",
     HeightKey:@70,
     WeightKey:@165,
     YearKey:@11,
     BioKey:@"Thomas is a junior at Woods Cross High School. He has been playing football since he was 7 years old. When he isn't playing football, he enjoys skiing, playing soccer, and hiking in the hills by his house.",
     IsCaptainKey:@0,
     IsStarterKey:@1,
     ViewsKey:@104};
     
     NSDictionary *athlete2 = @{AthleteIDKey:@2,
     NameKey:@"Junior Vailolo",
     JerseyNumberKey:@7,
     PhotoKey:@"junior_vailolo",
     PositionKey:@"RB",
     HeightKey:@70,
     WeightKey:@185,
     YearKey:@12,
     BioKey:@"Junior is a senior this year. Upon graduation, he plans on attending BYU to continue his football career. He loves teaching all of his younger brothers and cousins how to play football. His favorite food is flaming hot cheetos with mayonaise.",
     IsCaptainKey:@0,
     IsStarterKey:@1,
     ViewsKey:@319};
     
    
    
    NSDictionary *athlete3 = @{AthleteIDKey:@3,
                               NameKey:@"John Smith",
                               JerseyNumberKey:@12,
                               PhotoKey:@"john_smith",
                               PositionKey:@"LB",
                               HeightKey:@72,
                               WeightKey:@168,
                               YearKey:@12,
                               BioKey:@"John is a senior at Woods Cross. His teammates know him as the commander of crunch, because of his phenominal season last season as the state's best linebacker. He racked up 13 sacks and 44 total tackles throughout the season.",
                               IsCaptainKey:@0,
                               IsStarterKey:@1,
                               ViewsKey:@239};
    
    
    
    
    //    self.currentTeam = [[Team alloc]init];
    self.currentTeam = self.teams[0];
    
    NSMutableArray *athletesMutable = [[NSMutableArray alloc]init];
    //    athletesMutable = [self.currentTeam.athletes mutableCopy];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete1]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete2]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete3]];
    
    self.currentTeam.athletes = athletesMutable;
    self.currentAthlete = [Athlete new];
    self.currentAthlete = self.currentTeam.athletes[1];
    
}

@end