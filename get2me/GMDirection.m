//
//  GMDirection.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMDirection.h"
#import "GMRoute.h"

@implementation GMDirection

- (id)init {
	self = [super init];
	if (self != nil) {
		self.googleMapsAPI = [[GoogleMapsAPI alloc] init];
        self.googleSteps = [[NSMutableArray alloc] init];
		self.googleMapsAPI.delegate = self;
	}
	return self;
}

- (void)goolgeMapsAPI:(GoogleMapsAPI *)goolgeMapsAPI didGetObject:(NSObject *)object {
    
    self.googleRoute = (GMRoute *)object;
    self.googleLegs = self.googleRoute.legs;

    for (GMLeg *leg in self.googleLegs) {
        [self.googleSteps addObjectsFromArray: leg.steps];
    }
	if ([self.delegate respondsToSelector:@selector(directionsDidUpdateDirections:)]) {
		[self.delegate directionsDidUpdateDirections:self];
	}
}

- (void)goolgeMapsAPI:(GoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message {
	if ([self.delegate respondsToSelector:@selector(directions:didFailWithMessage:)]) {
		[self.delegate directions:self didFailWithMessage:message];
	}
}

-(void)googleRouteForRoute: (Route *) route
{
    self.route = route;
    [self.googleMapsAPI routeFrom: route.startLocation
                       toLocation: route.endLocation
                  withTransitMode: @"walking"];
}
- (NSInteger)numberOfSteps {
	return [self.googleSteps count];
}

- (GMStep *)stepAtIndex:(NSInteger)index {
	return [self.googleSteps objectAtIndex:index];
}

@end
