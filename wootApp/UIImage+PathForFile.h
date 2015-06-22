//
//  UIImage+PathForFile.h
//  wootApp
//
//  Created by Cole Wilkes on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PathForFile)

+ (void)imageWithPath:(NSString *)path WithCompletion:(void (^)(BOOL success, UIImage* image))completion;
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

@end
