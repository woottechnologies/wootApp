//
//  User.m
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "User.h"
#import "UserController.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.userID = [dictionary[UserIDKey] integerValue];
        self.username = dictionary[UsernameKey];
        //self.email = dictionary[EmailKey];
    }
    
    return self;
}

- (BOOL)isFollowing:(id)account {
    if ([account isKindOfClass:[Team class]]) {
        Team *team = account;
        
        for (NSDictionary *follow in self.following) {
            if ([[follow objectForKey:FollowingIDKey] integerValue] == team.teamID
                && [[follow objectForKey:FollowingTypeKey] isEqualToString:@"T"]) {
                return YES;
            }
        }
    } else {
        Athlete *athlete = account;
        
        for (NSDictionary *follow in self.following) {
            if ([[follow objectForKey:FollowingIDKey] integerValue] == athlete.athleteID
                && [[follow objectForKey:FollowingTypeKey] isEqualToString:@"A"]) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
