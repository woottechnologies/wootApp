//
//  SchoolController.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SchoolController.h"
#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@interface SchoolController()

@property (nonatomic, strong) NSArray *schools;

@end

@implementation SchoolController

+(instancetype) sharedInstance{
    static SchoolController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SchoolController alloc]init];
        [sharedInstance loadSchoolsFromDatabaseWithCompletion:^(BOOL success) {
            if (success) {
                NSLog(@"network request worked");
            } else {
                NSLog(@"fail");
            }
        }];
    });
    
    return sharedInstance;
}

- (void)loadSchoolsFromDatabaseWithCompletion:(void (^)(BOOL success))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"select_schools.php"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
        if (data.length > 0 && error == nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (responseArray.count > 0) {
                NSMutableArray *mutSchoolArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in responseArray) {
                    //NSLog(@"%@", dict);
                    School *newSchool = [[School alloc] initWithDictionary:dict];
                    [UIImage imageWithPath:[NSString stringWithFormat:@"%@", dict[LogoKey]] WithCompletion:^(BOOL success, UIImage *image) {
                        if (success) {
                            newSchool.logo = image;
                        }
                    }];
                    [mutSchoolArray addObject:newSchool];
                }
                
                self.schools = mutSchoolArray;
                self.currentSchool = self.schools[0];
                completion(YES);
            }
        } else {
            completion(NO);
        }
        
    }];
    
    [dataTask resume];
}

@end
