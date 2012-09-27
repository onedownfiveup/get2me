//
//  Direction.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/19/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "User.h"


@interface Direction : NSObject

@property (nonatomic, retain) NSString *directionId;
@property (nonatomic, retain) User     *user;
@property (nonatomic, retain) NSString *endCoordinateLatitude;
@property (nonatomic, retain) NSString *endCoordinateLongitude;
@property (nonatomic, retain) NSArray  *routes;

+(void) loadRestkitMappingsWithUserMapping: (RKObjectMapping *) userMapping;
@end
