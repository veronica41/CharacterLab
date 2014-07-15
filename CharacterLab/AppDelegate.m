//
//  AppDelegate.m
//  CharacterLab
//
//  Created by Pierpaolo Baccichet on 7/3/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "AppDelegate.h"
#import "CLModel.h"
#import "TraitsViewController.h"
#import "StudentsViewController.h"
#import "LoginViewController.h"

@interface AppDelegate () <LoginViewControllerDelegate>

@property (nonatomic, strong) UIViewController *mainViewController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize the Character Lab model client
    [CLModel setApplicationId:@"uZlzv42bdzha3eHuQq7Hb6cuWYxWeHqXc7U9bfhu"
                    clientKey:@"o9iiYvoduL1hul44RByxsjTYQa4VHrEvmIX2CwWs"];

    // set light status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.mainViewController = [[TraitsViewController alloc] init];
    if (![PFUser currentUser]) {
        LoginViewController *loginController = [[LoginViewController alloc] init];
        loginController.delegate = self;
        self.window.rootViewController = loginController;
    } else {
        self.window.rootViewController = self.mainViewController;
    }

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - LoginViewControllerDelegate

- (void)userDidLogin {
    [self.window.rootViewController presentViewController:self.mainViewController animated:NO completion:nil];
}

@end
