//
//  GoogleMapsAPI.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GoogleMapsAPI.h"

#define GOOGLE_DIRECTION_API @"https://maps.googleapis.com"

@implementation GoogleMapsAPI
- (id)init {
    self = [super init];
    self.objectManager = [RKObjectManager managerWithBaseURLString: GOOGLE_DIRECTION_API];

    [self loadGoogleMapObjectMappings];
    return self;
}


-(void) loadGoogleMapObjectMappings
{
    RKObjectMapping *legMapping  = [self legMapping];
    RKObjectMapping *routeMapping  = [self routeMappingWithChildMapping: legMapping];

    [self.objectManager.mappingProvider setObjectMapping:routeMapping forKeyPath: @"routes"];
}

-(RKObjectMapping *) routeMappingWithChildMapping: (RKObjectMapping *)legMapping
{
    RKObjectMapping *routeMapping = [RKObjectMapping mappingForClass: [GMRoute class]];
    [routeMapping mapKeyPath:@"legs" toRelationship:@"legs" withMapping: legMapping];
    [routeMapping mapKeyPath:@"overview_polyline.points" toAttribute:@"overviewPolyline"];

    [self.objectManager.mappingProvider setObjectMapping: legMapping forKeyPath: @"steps"];


    return routeMapping;
}

-(RKObjectMapping *) stepMapping
{
    RKObjectMapping *stepMapping = [RKObjectMapping mappingForClass: [GMStep class]];
    
    [stepMapping mapKeyPath:@"start_location.latitude" toAttribute:@"startCoordinateLatitude"];
    [stepMapping mapKeyPath:@"start_location.longitude" toAttribute:@"startCoordinateLongitude"];
    [stepMapping mapKeyPath:@"end_location.lat" toAttribute:@"endPointLatitude"];
    [stepMapping mapKeyPath:@"end_location.lng" toAttribute:@"endPointLongitude"];
    [stepMapping mapKeyPath:@"polyline" toAttribute:@"polyline"];
    [stepMapping mapKeyPath:@"duration.text" toAttribute:@"durationText"];
    [stepMapping mapKeyPath:@"distance.text" toAttribute:@"distanceText"];
    [stepMapping mapKeyPath:@"travel_mode" toAttribute:@"travelMode"];
    
    [self.objectManager.mappingProvider setObjectMapping:stepMapping forKeyPath: @"steps"];
    return stepMapping;
}

-(RKObjectMapping *) legMapping
{
    RKObjectMapping *stepMapping = [self stepMapping];
    RKObjectMapping *legMapping = [RKObjectMapping mappingForClass: [GMLeg class]];
    
    [legMapping mapKeyPath:@"steps" toRelationship:@"steps" withMapping: stepMapping];

    [self.objectManager.mappingProvider setObjectMapping:legMapping forKeyPath: @"leg"];
    return legMapping;
}


- (void)routeFrom: (CLLocation *) fromLocation
       toLocation: (CLLocation *) toLocation
  withTransitMode: (NSString *)   transitMode
{
    NSString *fromLatitude   = [[NSString alloc] initWithFormat:@"%.18g", fromLocation.coordinate.latitude];
    NSString *fromLongitude  = [[NSString alloc] initWithFormat:@"%.18g", fromLocation.coordinate.longitude];
    NSString *toLatitude     = [[NSString alloc] initWithFormat:@"%.18g", toLocation.coordinate.latitude];
    NSString *toLongitude    = [[NSString alloc] initWithFormat:@"%.18g", toLocation.coordinate.longitude];
    NSString *directionsPath = [[NSString alloc] initWithFormat:@"/maps/api/directions/json?origin=%@,%@&destination=%@,%@&mode=%@&sensor=true",
                                fromLatitude, fromLongitude,
                                toLatitude, toLongitude,
                                transitMode];

    [self.objectManager loadObjectsAtResourcePath: directionsPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      loader.method= RKRequestMethodGET;
                                      loader.delegate = self;
                                  }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(goolgeMapsAPI:didFailWithMessage:)]) {
        [(id<GoogleMapsAPIDelegate>)self.delegate goolgeMapsAPI:self didFailWithMessage:error.description];
    }

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Result is %@", objectLoader.response.bodyAsString);
    
    if ([self.delegate respondsToSelector:@selector(goolgeMapsAPI:didGetObject:)]) {
		[(id<GoogleMapsAPIDelegate>)self.delegate goolgeMapsAPI:self didGetObject:[objects objectAtIndex:0]];
	}
}

@end