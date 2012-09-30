//
//  GMoogleMapsAPI.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GMRoute.h"
#import "GMStep.h"

@class GMPolyline, GoogleMapsAPI;

@protocol GoogleMapsAPIDelegate<NSObject>
@optional
- (void)goolgeMapsAPI:(GoogleMapsAPI *)goolgeMapsAPI didGetObject:(NSObject *)object;
- (void)goolgeMapsAPI:(GoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message;
@end

@interface GoogleMapsAPI : NSObject <RKObjectLoaderDelegate>
@property(nonatomic, assign) id <GoogleMapsAPIDelegate> delegate;
@property (retain, nonatomic) RKObjectManager *objectManager;

@end
