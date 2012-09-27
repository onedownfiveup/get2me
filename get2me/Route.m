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
                                 andUserMapping: (RKObjectMapping *) userMapping
{
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    RKObjectMapping *routeMapping = [RKObjectMapping mappingForClass: [Route class]];
    
    [routeMapping mapKeyPath:@"_id" toAttribute:@"routeId"];
    [routeMapping mapKeyPath:@"start_coordinates.latitude" toAttribute:@"startCoordinateLatitude"];
    [routeMapping mapKeyPath:@"start_coordinates.longitude" toAttribute:@"startCoordinateLongitude"];
    [routeMapping mapKeyPath:@"end_coordinates.latitude" toAttribute:@"endCoordinateLatitude"];
    [routeMapping mapKeyPath:@"end_coordinates.longitude" toAttribute:@"endCoordinateLongitude"];
    [routeMapping mapKeyPath:@"allow_tracking" toAttribute:@"allowTracking"];
    [routeMapping mapKeyPath:@"state" toAttribute:@"state"];

    [routeMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];

    [directionMapping mapKeyPath:@"routes" toRelationship:@"routes" withMapping: routeMapping];
    [sharedManager.mappingProvider setObjectMapping:routeMapping forKeyPath: @"routes"];
}
@end

