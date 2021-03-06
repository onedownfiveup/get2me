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
#import "MapViewViewController.h"
#import "UAirship.h"
#import "UAPush.h"
#import <CoreLocation/CoreLocation.h>
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

    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey: UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];

    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    UALOG(@"APN device token: %@", deviceToken);
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
}

-(void) loadRestkitDefaults
{
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://gettome.herokuapp.com/"];
//    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://get2me.local/"];
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
 
    NSString *viewIdentifier = @"mapViewController";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle: nil];
    MapViewViewController *mapViewController = [storyBoard instantiateViewControllerWithIdentifier:viewIdentifier];
    
    if ([[CurrentUser sharedInstance] isLoggedIn]) {
        self.window.rootViewController = mapViewController;
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
