//
//  GMDirectionsOptions.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GMTravelModes {
	GMTravelModeDriving, // G_TRAVEL_MODE_DRIVING
	GMTravelModeWalking  // G_TRAVEL_MODE_WALKING
} GMTravelModes;

@interface GMDirectionsOptions : NSObject {
	NSLocale *locale;
	GMTravelModes travelMode;
	BOOL avoidHighways;
	BOOL getPolyline;
	BOOL getSteps;
	BOOL preserveViewport;
}

@property (nonatomic, retain) NSLocale *locale;
@property (nonatomic) GMTravelModes travelMode;
@property (nonatomic) BOOL avoidHighways;
@property (nonatomic) BOOL getPolyline;
@property (nonatomic) BOOL getSteps;
@property (nonatomic) BOOL preserveViewport;

@end
