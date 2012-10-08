//
//  CRUser.h
//  MobileShopper2
//
//  Created by Constantine Mavromoustakos on 7/19/12.
//  Copyright (c) 2012Consumer Reports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
#import "User.h"
#import <RestKit/RestKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


extern NSString *const CRUserAuthUrl;
extern NSString *const CRUserAuthAPIKey;

@interface CurrentUser : NSObject <CLLocationManagerDelegate, RKObjectLoaderDelegate>
{
    KeychainItemWrapper *keychain;
    NSString *resultsJSON;
}
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) KeychainItemWrapper *keychain; 
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) CLLocationManager *locationManager;

-(void) storeUsernameInKeyChain: (NSString *) username
                   withPassword: (NSString *) password;
-(BOOL) isLoggedIn;
-(void) signoutUser;
-(void) updateLocationOnServer: (CLLocation *) currentLocation;

-(NSString *)    userName;
+(CurrentUser *) sharedInstance;
@end