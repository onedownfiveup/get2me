//
//  GMDirections.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMDirections.h"
#import "GMRoute.h"

static GMDirections *sharedDirections;

@implementation GMDirections

@synthesize routes;
@synthesize geocodes;
@synthesize distance;
@synthesize duration;
@synthesize status;
@synthesize isInitialized;

+ (GMDirections *)sharedDirections {
	if (!sharedDirections) {
		sharedDirections = [[GMDirections alloc] init];
	}
	return sharedDirections;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		googleMapsAPI = [[GoogleMapsAPI alloc] init];
		googleMapsAPI.delegate = self;
	}
	return self;
}

- (void)goolgeMapsAPI:(GoogleMapsAPI *)goolgeMapsAPI didGetObject:(NSObject *)object {
	NSDictionary *dictionary = (NSDictionary *)object;
	NSArray *routeDics = [dictionary objectForKey:@"routes"];
	routes = [[NSMutableArray alloc] initWithCapacity:[routeDics count]];
    
	self.geocodes = [dictionary objectForKey:@"geocodes"];
	self.distance = [dictionary objectForKey:@"distance"];
	self.duration = [dictionary objectForKey:@"duration"];
	self.status = [dictionary objectForKey:@"status"];
	
	if ([self.delegate respondsToSelector:@selector(directionsDidUpdateDirections:)]) {
		[self.delegate directionsDidUpdateDirections:self];
	}
}

- (void)goolgeMapsAPI:(GoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message {
	if ([self.delegate respondsToSelector:@selector(directions:didFailWithMessage:)]) {
		[self.delegate directions:self didFailWithMessage:message];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	isInitialized = YES;
	if ([self.delegate respondsToSelector:@selector(directionsDidFinishInitialize:)]) {
		[self.delegate directionsDidFinishInitialize:self];
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if ([self.delegate respondsToSelector:@selector(directions:didFailInitializeWithError:)]) {
		[self.delegate directions:self didFailInitializeWithError:error];
	}
}

- (NSInteger)numberOfRoutes {
	return [routes count];
}

- (GMRoute *)routeAtIndex:(NSInteger)index {
	return [routes objectAtIndex:index];
}

- (NSInteger)numberOfGeocodes {
	return [geocodes count];
}

- (NSDictionary *)geocodeAtIndex:(NSInteger)index {
	return [geocodes objectAtIndex:index];;
}

@end
