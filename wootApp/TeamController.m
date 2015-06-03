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
    self.teams = [[NSArray alloc] init];
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
                                        IsCaptainKey:@0,
                                        IsStarterKey:@1,
                                        ViewsKey:@239};
    
    
    self.currentTeam = self.teams[0];
    
    NSMutableArray *athletesMutable = [[NSMutableArray alloc] init];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete1]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete2]];
    [athletesMutable addObject:[[Athlete alloc] initWithDictionary:athlete3]];
    
    self.currentTeam.athletes = athletesMutable;
}

@end
