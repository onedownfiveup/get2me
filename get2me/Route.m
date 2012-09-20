//
//  Route.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/19/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "Route.h"

@implementation Route

+(void) loadRestkitMappingsWithDirectionMapping: (RKObjectMapping *) directionMapping
{
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    RKObjectMapping *routeMapping = [RKObjectMapping mappingForClass: [Route class]];
    
    [routeMapping mapKeyPath:@"_id" toAttribute:@"routeId"];
    [directionMapping mapKeyPath:@"routes" toRelationship:@"route" withMapping: routeMapping];
    
    
    [sharedManager.mappingProvider setObjectMapping:directionMapping forKeyPath: @"direction"];
}
@end

