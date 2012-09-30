//
//  GMRoute.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GMLeg.h"

@interface GMRoute : NSObject

@property (nonatomic, retain, readonly) NSArray *legs;

- (GMLeg *)legAtIndex:(NSInteger)index;

@end
