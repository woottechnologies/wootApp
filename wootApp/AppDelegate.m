//
//  AppDelegate.m
//  wootApp
//
//  Created by Egan Anderson on 6/2/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "SchoolListViewController.h"
#import "CustomTabBarVC.h"
#import "TestViewController.h"
#import "TeamViewController.h"
#import "AthleteViewController.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "UserProfileViewController.h"
#import "HomeFeedViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *masterVC = [[UINavigationController alloc] initWithRootViewController:[SchoolListViewController new]];
//    UINavigationController *masterVC = [[UINavigationController alloc] initWithRootViewController:[HomeFeedViewController new]];
    
    masterVC.tabBarItem = [[UITabBarItem alloc] init];
    
    UINavigationController *userProfile = [[UINavigationController alloc] initWithRootViewController:[UserProfileViewController new]];

    CustomTabBarVC *tabBarVC = [[CustomTabBarVC alloc] init];
    tabBarVC.viewControllers = @[masterVC, userProfile];

    self.window.rootViewController = tabBarVC;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [[Twitter sharedInstance] startWithConsumerKey:@"4XKVAaWK76YUhrEpzMA0IlxSN" consumerSecret:@"IZjo0qtCXj58DJWambtbsZuJhONqV7U8YdjXPIKRF11YApj49u"];
    [Fabric with:@[[Twitter sharedInstance]]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
