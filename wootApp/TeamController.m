//
//  TeamController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamController.h"
#import "Team.h"

@interface TeamController()

@property (nonatomic, strong) NSArray *teams;

@end

@implementation TeamController

+ (instancetype)sharedInstance {
    static TeamController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TeamController alloc] init];
    });
    
    return sharedInstance;
}

- (void)loadTeams {
    NSDictionary *wxFBTeamDict = @{TeamIDKey:@1,
                                     SchoolIDKey:@1,
                                     TypeKey:@"Football",
                                     WinsKey:@4,
                                     LossesKey:@1};
    
    NSMutableArray *teamsMutable = [[NSMutableArray alloc] init];
    Team *wxFootball = [[Team alloc] initWithDictionary:wxFBTeamDict];
    
    [teamsMutable addObject:wxFootball];
    
    self.teams = teamsMutable;
}

- (void)loadAthletes {
    
    /*
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
    
    NSDictionary *athlete1 = @{AthleteIDKey:@2,
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
     */
    
    for (Team *team in self.teams) {
        
    }
}

@end
