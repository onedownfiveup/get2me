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

extern NSString *const CRUserAuthUrl;
extern NSString *const CRUserAuthAPIKey;

@interface CurrentUser : NSObject
{
    KeychainItemWrapper *keychain;
    NSString *resultsJSON;
}

@property (nonatomic, retain) KeychainItemWrapper *keychain; 
@property (nonatomic, retain) User *user;

-(void) storeUsernameInKeyChain: (NSString *) username
                   withPassword: (NSString *) password;
-(BOOL) isLoggedIn;
-(void) signoutUser;

-(NSString *)    userName;
+(CurrentUser *) sharedInstance;
@end