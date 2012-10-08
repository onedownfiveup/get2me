//
//  CurrentUser.m
//  Get2me
//
//  Created by Constantine Mavromoustakos on 7/19/12.
//  Copyright (c) 2012Consumer Reports. All rights reserved.
//

#import "CurrentUser.h"

static CurrentUser *sharedInstance = nil;
static dispatch_queue_t serialQueue;

@implementation CurrentUser
@synthesize keychain;

-(id)init
{
    id __block obj;
    
    dispatch_sync(serialQueue, ^{
        obj = [super init];
        if (obj) {
            self.keychain  = [[KeychainItemWrapper alloc] initWithIdentifier: @"GET2ME"
                                                                 accessGroup: nil];
        }
    });
    
    self = [super init];
    return self;
}


+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        serialQueue = dispatch_queue_create("com.get2me.CurrentUser.SerialQueue", NULL);
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
        }
    });
    
    return sharedInstance;
}

+ (CurrentUser *)sharedInstance {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[CurrentUser alloc] init];
        
        sharedInstance.locationManager =  [[CLLocationManager alloc] init];
        sharedInstance.locationManager.delegate = sharedInstance;
        [sharedInstance.locationManager startUpdatingLocation];
        sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        sharedInstance.locationManager.distanceFilter = 100.0f;
    });
    
    
    return sharedInstance;
}

-(void) setCurrentLocation:(CLLocation *)currentLocation
{
    _currentLocation = currentLocation;
    [self updateLocationOnServer: currentLocation];
}

-(void) setUser:(User *)user
{
    _user = user;
    self.currentLocation = self.locationManager.location;
}

-(void) storeUsernameInKeyChain: (NSString *) username
                   withPassword: (NSString *) password
{
    // Store username to keychain 	
    if (username)
        [keychain setObject: username forKey:(__bridge id)kSecAttrAccount];
    
    // Store password to keychain
    if (password)
        [keychain setObject: password forKey:(__bridge id)kSecValueData];
}

-(void)signoutUser
{
    [keychain setObject: @"" forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject: @"" forKey:(__bridge id)kSecValueData];
}

-(BOOL)isLoggedIn
{
    
    return self.user != nil;
}

-(NSString *)userName
{
    return  [self.keychain objectForKey:(__bridge id)kSecAttrAccount];
}

-(NSString *)password
{
    return  [self.keychain objectForKey:(__bridge id)kSecValueData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.user) {
        self.currentLocation = [locations objectAtIndex: 0];
    }
}

-(void)updateLocationOnServer: (CLLocation *) currentLocation
{
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    NSString *userLocationPath = [NSString stringWithFormat: @"/api/v1/users/%@/location.json", self.user.userId];
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.longitude];

    [sharedManager loadObjectsAtResourcePath: userLocationPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      RKParams *params= [RKParams params];
                                      [params setValue: self.user.token
                                              forParam: @"auth_token"];
                                      [params setValue: latitude
                                              forParam: @"user[current_location][latitude]"];
                                      [params setValue: longitude
                                              forParam: @"user[current_location][longitude]"];
                                      loader.params = params;
                                      loader.method= RKRequestMethodPUT;
                                      loader.delegate = self;
                                  }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
}

@end
