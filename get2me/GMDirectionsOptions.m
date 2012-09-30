//
//  GMDirectionsOptions.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMDirectionsOptions.h"

@implementation GMDirectionsOptions

@synthesize locale;
@synthesize travelMode;
@synthesize avoidHighways;
@synthesize getPolyline;
@synthesize getSteps;
@synthesize preserveViewport;

- (id)init {
	self = [super init];
	if (self != nil) {
		locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
		travelMode = GMTravelModeDriving;
		avoidHighways = NO;
		getPolyline = YES;
		getSteps = YES;
		preserveViewport = NO;
	}
	return self;
}

- (NSString *)JSONRepresentation {
	return [NSString stringWithFormat:
			@"{ 'locale': '%@', travelMode: %@, avoidHighways: %@, getPolyline: %@, getSteps: %@, preserveViewport: %@}", 
			[locale localeIdentifier], 
			travelMode == GMTravelModeDriving ? @"G_TRAVEL_MODE_DRIVING" : @"G_TRAVEL_MODE_WALKING",
			avoidHighways ? @"true" : @"false",
			getPolyline ? @"true" : @"false",
			getSteps ? @"true" : @"false",	
			preserveViewport ? @"true" : @"false"];
}

@end
