//
//  TeamController.h
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamController : NSObject

@property (nonatomic, strong, readonly) NSArray *teams;
@property (nonatomic, assign) NSInteger schoolID;

+ (instancetype)sharedInstance;

@end
