//
//  AppDelegate.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "AppDelegate.h"
#import "AllergiesViewController.h"
#import "SearchViewController.h"
#import "AboutViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *allergiesViewController =
        [[AllergiesViewController alloc] init];
    [allergiesViewController setTabBarItem: [[UITabBarItem alloc] initWithTitle:@"Allergies" image:[UIImage imageNamed:@"man"] tag:0]];
    
    UINavigationController *searchViewController =
        [[SearchViewController alloc] init];
    [searchViewController setTabBarItem:
        [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1]];
    
    UINavigationController *aboutViewController =
        [[AboutViewController alloc] init];
    [aboutViewController setTabBarItem: [[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"lightbulb"] tag:2]];
    
    UIViewController *rootViewController;
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad:
            rootViewController = [[UISplitViewController alloc] init];
            [(UISplitViewController *) rootViewController setViewControllers:@[allergiesViewController, searchViewController]];
            break;
        case UIUserInterfaceIdiomPhone:
            rootViewController = [[UITabBarController alloc] init];
            [(UITabBarController *)rootViewController
                setViewControllers:@[allergiesViewController, searchViewController, aboutViewController]];
            break;
    }
    
    self.window.rootViewController = rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
    
}

@end
