//
//  GMDirections.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMDirectionsOptions.h"
#import "GMRoute.h"
#import "GoogleMapsAPI.h"

@class GMDirections;

@protocol GMDirectionsDelegate<NSObject>
@optional
- (void)directionsDidFinishInitialize:(GMDirections *)directions;
- (void)directions:(GMDirections *)directions didFailInitializeWithError:(NSError *)error;
- (void)directionsDidUpdateDirections:(GMDirections *)directions;
- (void)directions:(GMDirections *)directions didFailWithMessage:(NSString *)message;
@end

@interface GMDirections : NSObject<GoogleMapsAPIDelegate> {
	id<GMDirectionsDelegate> delegate;
	GoogleMapsAPI *googleMapsAPI;
	NSArray *routes;
	NSArray *geocodes;
	NSDictionary *distance;
	NSDictionary *duration;
	NSDictionary *status;
	BOOL isInitialized;
}

@property (nonatomic, assign) id<GMDirectionsDelegate> delegate;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSArray *geocodes;
@property (nonatomic, retain) NSDictionary *distance;
@property (nonatomic, retain) NSDictionary *duration;
@property (nonatomic, retain) NSDictionary *status;
@property (nonatomic, readonly) BOOL isInitialized;

+ (GMDirections *)sharedDirections;
- (id)init;
- (void)makeAvailable;
- (void)loadWithQuery:(NSString *)query options:(GMDirectionsOptions *)options;
- (void)loadWithStartPoint:(NSString *)startPoint endPoint:(NSString *)endPoint options:(GMDirectionsOptions *)options;
- (void)loadFromWaypoints:(NSArray *)waypoints options:(GMDirectionsOptions *)options;
- (void)clear;
- (NSInteger)numberOfRoutes;
- (GMRoute *)routeAtIndex:(NSInteger)index;
- (NSInteger)numberOfGeocodes;
- (NSDictionary *)geocodeAtIndex:(NSInteger)index;

@end
