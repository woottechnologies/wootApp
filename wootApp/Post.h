//
//  Post.h
//  wootApp
//
//  Created by Cole Wilkes on 8/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSString *PostIDKey = @"id";
static NSString *TextKey = @"text";
static NSString *PostPhotoKey = @"image";
static NSString *TimestampKey = @"timestamp";

@interface Post : NSObject

@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSDate *timestamp;

@end
