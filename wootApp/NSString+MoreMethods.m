//
//  NSString+MoreMethods.m
//  wootApp
//
//  Created by Cole Wilkes on 6/30/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "NSString+MoreMethods.h"

@implementation NSString (MoreMethods)

-(BOOL)isValidEmail{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
