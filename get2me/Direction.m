//
//  Direction.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/19/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "Direction.h"

@implementation Direction

+(void) loadRestkitMappingsWithUserMapping: (RKObjectMapping *) userMapping
{
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    RKObjectMapping *directionMapping = [RKObjectMapping mappingForClass: [Direction class]];
    
    [directionMapping mapKeyPath:@"_id" toAttribute:@"directionId"];    
    [directionMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];

    
    [sharedManager.mappingProvider setObjectMapping:directionMapping forKeyPath: @"direction"];
}
@end