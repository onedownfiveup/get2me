//
//  User.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/15/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "User.h"
#import <RestKit/RestKit.h>

@implementation User


+(void) loadRestkitMappings
{
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass: [User class]];
    
    [userMapping mapKeyPath:@"_id" toAttribute:@"userId"];
    [userMapping mapKeyPath:@"token" toAttribute:@"token"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
    [userMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
    
    [sharedManager.mappingProvider setObjectMapping:userMapping forKeyPath: @"user"];
    [sharedManager.mappingProvider setObjectMapping:userMapping forKeyPath: @"friends"];
}
@end
