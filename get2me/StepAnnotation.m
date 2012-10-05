//
//  StepAnnotation.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 10/5/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "StepAnnotation.h"

@implementation StepAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
				   title:(NSString *)aTitle
                subtitle:(NSString *)aSubtitle  {
	self = [super init];
	if (self != nil) {
		self.coordinate = coord;
		self.title = aTitle;
        self.subtitle = aSubtitle;
	}
	return self;
}

@end
