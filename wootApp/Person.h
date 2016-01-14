//
//  Person.h
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSString *PersonIDKey = @"id";
static NSString *PersonUserName = @"handle";
static NSString *PersonNameKey = @"name";
static NSString *PersonPhotoKey = @"photo";
static NSString *HeaderPhotoKey = @"headerPhoto";
static NSString *PersonViewsKey = @"views";

@interface Person : NSObject

@property (nonatomic, assign) NSInteger personID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *headerPhoto;
@property (nonatomic, assign) NSInteger views;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
