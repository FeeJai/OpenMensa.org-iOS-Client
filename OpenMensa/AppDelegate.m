//
//  AppDelegate.m
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

// Icons are from: http://glyphish.com/


#import "AppDelegate.h"

#import "ShowMenuNavigationController.h"
#import "AddFavouriteMapViewController.h"
#import "SocialViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UINavigationController *viewController1 = [[ShowMenuNavigationController alloc] initWithNibName:nil bundle:nil];

    UIViewController *viewController2 = [[AddFavouriteMapViewController alloc] initWithNibName:@"AddFavouriteMapViewController" bundle:nil];
    UIViewController *viewController3 = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3];
    [[self.tabBarController.viewControllers objectAtIndex:0] setTitle:NSLocalizedString(@"Speiseplan anzeigen", @"Menu")];

    self.window.rootViewController = self.tabBarController;
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
    [(ShowMenuNavigationController*) [self.tabBarController.viewControllers objectAtIndex:0] APIDataHasBeenUpdated];
    [(AddFavouriteMapViewController*) [self.tabBarController.viewControllers objectAtIndex:1] refreshPins];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
        
    if([viewController isKindOfClass:[ShowMenuNavigationController class]]) {
        [(ShowMenuNavigationController*) viewController APIDataHasBeenUpdated];
    } else if([viewController isKindOfClass:[AddFavouriteMapViewController class]]) {
        [(AddFavouriteMapViewController*) viewController refreshPins];
    }
            
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
