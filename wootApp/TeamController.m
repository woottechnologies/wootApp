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
    NSLog(@"load athletes called");
    
     NSDictionary *athlete1 = @{AthleteIDKey:@1,
                                NameKey:@"Thomas Moore",
                                JerseyNumberKey:@15,
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
                                JerseyNumberKey:@41,
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
                               JerseyNumberKey:@34,
                               PhotoKey:@"john_smith",
                               PositionKey:@"LB",
                               HeightKey:@72,
                               WeightKey:@168,
                               YearKey:@12,
                               BioKey:@"John is a senior at Woods Cross. His teammates know him as the commander of crunch, because of his phenominal season last season as the state's best linebacker. He racked up 13 sacks and 44 total tackles throughout the season.",
                               IsCaptainKey:@1,
                               IsStarterKey:@1,
                               ViewsKey:@239};
    
    NSDictionary *athlete4 = @{AthleteIDKey:@4,
                               NameKey:@"Teni Tuai",
                               JerseyNumberKey:@41,
                               PhotoKey:@"teni_tuai",
                               PositionKey:@"RB",
                               HeightKey:@70,
                               WeightKey:@185,
                               YearKey:@12,
                               BioKey:@"Teni is a senior this year. Upon graduation, he plans on attending BYU to continue his football career. He loves teaching all of his younger brothers and cousins how to play football. His favorite food is flaming hot cheetos with mayonaise.",
                               IsCaptainKey:@0,
                               IsStarterKey:@1,
                               ViewsKey:@3};
    
    NSDictionary *athlete5 = @{AthleteIDKey:@5,
                               NameKey:@"James Hawker",
                               JerseyNumberKey:@34,
                               PhotoKey:@"james_hawker",
                               PositionKey:@"LB",
                               HeightKey:@72,
                               WeightKey:@168,
                               YearKey:@12,
                               BioKey:@"James is a senior at Woods Cross. His teammates know him as the commander of crunch, because of his phenominal season last season as the state's best linebacker. He racked up 13 sacks and 44 total tackles throughout the season.",
                               IsCaptainKey:@1,
                               IsStarterKey:@1,
                               ViewsKey:@23};

    
    
    
    
    //    self.currentTeam = [[Team alloc]init];
    self.currentTeam = self.teams[0];
    
    NSMutableArray *athletesMutable = [[NSMutableArray alloc]init];
    //    athletesMutable = [self.currentTeam.athletes mutableCopy];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete1]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete2]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete3]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete4]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete5]];

    
    self.currentTeam.athletes = athletesMutable;
//    self.currentAthlete = [Athlete new];
    self.currentAthlete = self.currentTeam.athletes[2];
    
}

- (NSArray *) mostViewedAthletes{
    //[self loadAthletes];
    NSMutableArray *mostViewed = [[NSMutableArray alloc] init];
    while (mostViewed.count < 5) {
        Athlete *topAthlete = [Athlete new];
        topAthlete.views = -1;
        for (Athlete *athlete in self.currentTeam.athletes){
            if (athlete.views > topAthlete.views && ![mostViewed containsObject:athlete]) {
                topAthlete = athlete;
            }
        }
        [mostViewed addObject:topAthlete];
    }
    return mostViewed;
}

- (NSArray *) sortRosterByNumber{
    NSMutableArray *roster = [[NSMutableArray alloc] init];
    NSMutableArray *unsortedRoster = [self.currentTeam.athletes mutableCopy];
    while (roster.count < self.currentTeam.athletes.count){
        Athlete *athleteWithSmallestNumber = [Athlete new];
        athleteWithSmallestNumber.jerseyNumber = 999999;
        for (Athlete *athlete in unsortedRoster){
            if (athlete.jerseyNumber < athleteWithSmallestNumber.jerseyNumber){
                athleteWithSmallestNumber = athlete;
            }
                
        }
        [roster addObject:athleteWithSmallestNumber];
        [unsortedRoster removeObject:athleteWithSmallestNumber];
    }
    return roster;
}


@end