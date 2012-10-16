//
//  GMLeg.h
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/30/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GMStep.h"

@class GMStep;

@interface GMLeg : NSObject

@property (nonatomic, readonly)         NSInteger numerOfSteps;
@property (nonatomic, retain)           NSMutableArray *steps;
@property (nonatomic, retain, readonly) NSDictionary *distance;
@property (nonatomic, retain, readonly) NSDictionary *duration;
@property (nonatomic, retain, readonly) NSString *startAddress;
@property (nonatomic, retain, readonly) NSString *endAddress;
@property (nonatomic, retain, readonly) CLLocation *endLocation;
@property (nonatomic, retain, readonly) CLLocation *startLocation;

@end
