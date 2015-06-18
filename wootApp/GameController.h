//
//  GameController.h
//  wootApp
//
//  Created by Cole Wilkes on 6/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface GameController : NSObject

@property (nonatomic, strong) Game *currentGame;

+ (instancetype)sharedInstance;
- (void)allGamesForTeam:(Team *)team WithCompletion:(void (^)(BOOL success, NSArray *games))completion;

@end
