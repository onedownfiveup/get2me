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
    });
    
    return sharedInstance;
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

@end
