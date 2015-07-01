//
//  Coach.h
//  wootApp
//
//  Created by Cole Wilkes on 6/29/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


static NSString *CoachIDKey = @"id";
static NSString *TitleKey = @"title";
static NSString *CoachNameKey = @"name";
static NSString *CoachPhotoKey = @"photo";

@interface Coach : NSObject

@property (nonatomic, assign) NSInteger coachID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *photo;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
