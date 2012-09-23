//
//  RailzbizAppDelegate.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/12/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "Get2meAppDelegate.h"
#import "CurrentUser.h"
#import "User.h"
#import "Direction.h"
#import "SignInViewController.h"
#import "Get2meTabBarViewController.h"

@implementation Get2meAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadRestkitDefaults];
    NSString *viewIdentifier = @"signInController";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle: nil];
    SignInViewController *signInViewController = [storyBoard instantiateViewControllerWithIdentifier:viewIdentifier];
    
    if (![[CurrentUser sharedInstance] isLoggedIn]) {
        self.window.rootViewController = signInViewController;
        [self.window makeKeyAndVisible];
    }
    
    [self setupUserLoginNotification];
    return YES;
}

-(void) loadRestkitDefaults
{
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://gettome.herokuapp.com"];
    [RKObjectManager setSharedManager: self.objectManager];
    [User loadRestkitMappings];
}

-(void)setupUserLoginNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserStateChange)
                                                 name:@"CurrentUserStateChange"
                                               object:nil];
}

-(void)handleUserStateChange
{
 
    NSString *viewIdentifier = @"tabBarController";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle: nil];
    Get2meTabBarViewController *get2meTabBarViewController = [storyBoard instantiateViewControllerWithIdentifier:viewIdentifier];
    
    if ([[CurrentUser sharedInstance] isLoggedIn]) {
        self.window.rootViewController = get2meTabBarViewController;
        [self.window makeKeyAndVisible];
    }
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

@end
