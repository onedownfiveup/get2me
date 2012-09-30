//
//  GoogleMapsAPI.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GoogleMapsAPI.h"

#define GOOGLE_DIRECTION_API @"https://maps.googleapis.com/maps/api/directions/json"

@implementation GoogleMapsAPI
- (id)init {
    self = [super init];
    self.objectManager = [RKObjectManager managerWithBaseURLString: GOOGLE_DIRECTION_API];

    [self loadGoogleMapObjectMappings];
    return self;
}


-(void) loadGoogleMapObjectMappings
{
    RKObjectMapping *stepMapping  = [self stepMapping];
    RKObjectMapping *routeMapping  = [self routeMappingWithChildMapping: stepMapping];

    [self.objectManager.mappingProvider setObjectMapping:routeMapping forKeyPath: @"routes"];
}

-(RKObjectMapping *) routeMappingWithChildMapping: (RKObjectMapping *)stepMapping
{
    RKObjectMapping *routeMapping = [RKObjectMapping mappingForClass: [GMRoute class]];
    [routeMapping mapKeyPath:@"steps" toRelationship:@"steps" withMapping: stepMapping];
    
    [self.objectManager.mappingProvider setObjectMapping:stepMapping forKeyPath: @"steps"];


    return routeMapping;
}

-(RKObjectMapping *) stepMapping
{
    RKObjectMapping *stepMapping = [RKObjectMapping mappingForClass: [GMStep class]];
    
    [self.objectManager.mappingProvider setObjectMapping:stepMapping forKeyPath: @"steps"];
    return stepMapping;
}

- (void)routeFrom: (CLLocation *) fromLocation
       toLocation: (CLLocation *) toLocation
  withTransitMode: (NSString *)   transitMode
{
    NSString *fromLatitude   = [[NSString alloc] initWithFormat:@"%f", fromLocation.coordinate.latitude];
    NSString *fromLongitude  = [[NSString alloc] initWithFormat:@"%f", fromLocation.coordinate.longitude];
    NSString *toLatitude     = [[NSString alloc] initWithFormat:@"%f", toLocation.coordinate.latitude];
    NSString *toLongitude    = [[NSString alloc] initWithFormat:@"%f", toLocation.coordinate.longitude];
    NSString *directionsPath = [[NSString alloc] initWithFormat:@"?origin=%@,%@&destination=%@,%@&mode=%@&sensor=true",
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
    if ([self.delegate respondsToSelector:@selector(goolgeMapsAPI:didGetObject:)]) {
		[(id<GoogleMapsAPIDelegate>)self.delegate goolgeMapsAPI:self didGetObject:[objects objectAtIndex: 0]];
	}
}

@end