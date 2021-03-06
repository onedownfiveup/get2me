//
//  GMStep.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GMLeg.h"

@class GMLeg;

@interface GMStep : NSObject

@property (nonatomic, retain, readonly) NSString  *polyline;
@property (nonatomic, retain, readonly) NSString  *descriptionHtml;
@property (nonatomic, retain, readonly) NSString  *distanceText;
@property (nonatomic, retain, readonly) NSString  *durationText;
@property (nonatomic, retain, readonly) NSString  *travelMode;
@property (nonatomic, retain, readonly) NSString  *startPointLatitude;
@property (nonatomic, retain, readonly) NSString  *startPointLongitude;
@property (nonatomic, retain, readonly) NSString  *endPointLatitude;
@property (nonatomic, retain, readonly) NSString  *endPointLongitude;
@property (nonatomic, weak) GMLeg *leg;

-(NSString *) stepDirections;
-(CLLocation *) startLocation;
-(CLLocation *) endLocation;
@end
