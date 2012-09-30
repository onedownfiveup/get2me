//
//  GMRouteAnnotation.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMRouteAnnotation.h"

@implementation GMRouteAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize annotationType;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
				   title:(NSString *)aTitle 
		  annotationType:(GMRouteAnnotationType)type {
	self = [super init];
	if (self != nil) {
		coordinate = coord;
		title = aTitle;
		annotationType = type;
	}
	return self;
}

@end
