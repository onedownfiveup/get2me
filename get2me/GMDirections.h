//
//  GMDirections.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRoute.h"
#import "Route.h"
#import "GoogleMapsAPI.h"

@class GMDirections;

@protocol GMDirectionsDelegate<NSObject>
@optional
- (void)directionsDidFinishInitialize:(GMDirections *)directions;
- (void)directions:(GMDirections *)directions didFailInitializeWithError:(NSError *)error;
- (void)directionsDidUpdateDirections:(GMDirections *)directions;
- (void)directions:(GMDirections *)directions didFailWithMessage:(NSString *)message;
@end

@interface GMDirections : NSObject<GoogleMapsAPIDelegate>
@property (nonatomic, assign) id<GMDirectionsDelegate> delegate;
@property (nonatomic, retain) Route *route;
@property (nonatomic, retain) GMRoute *googleRoute;
@property (nonatomic, retain) NSArray *googleLegs;
@property (nonatomic, retain) NSMutableArray *googleSteps;
@property (nonatomic, retain) GoogleMapsAPI *googleMapsAPI;


- (NSInteger)numberOfRoutes;
- (GMRoute *)routeAtIndex:(NSInteger)index;
- (void)googleRouteForRoute: (Route *) route;

@end
