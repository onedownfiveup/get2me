//
//  Route.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/19/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "User.h"
#import "Direction.h"

@interface Route : NSObject

@property (nonatomic, retain) NSString *routeId;
@property (nonatomic, retain) User     *user;
@property (nonatomic, retain) NSString *endCoordinateLatitude;
@property (nonatomic, retain) NSString *endCoordinateLongitude;
@property (nonatomic, retain) NSString *startCoordinateLatitude;
@property (nonatomic, retain) NSString *startCoordinateLongitude;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, assign) Direction *direction;
@property (nonatomic, assign) BOOL     allowTracking;

+(void) loadRestkitMappingsWithDirectionMapping: (RKObjectMapping *) directionMapping
                                 andUserMapping: (RKObjectMapping *) userMapping;
-(BOOL) isAccepted;
-(CLLocation *) startLocation;
-(CLLocation *) endLocation;
-(NSString *) titleForAnnotation;

@end
