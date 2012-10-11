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

-(MKAnnotationView *)viewForAnnotationWithMapView: (MKMapView *)mapview;
{
    // try to dequeue an existing annotation view first
    static NSString* stepAnnotationIdentifier = @"stepAnnotation";
    MKAnnotationView* annotationView = (MKAnnotationView *)
    
    [mapview dequeueReusableAnnotationViewWithIdentifier:stepAnnotationIdentifier];
    if (!annotationView)
    {
        // if an existing annotation view was not available, create one
        MKAnnotationView* customannotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                              reuseIdentifier:stepAnnotationIdentifier];
        
        UIImage *directionImage = [UIImage imageNamed: @"walking"];
        customannotationView.image = directionImage;
        customannotationView.canShowCallout = YES;
        
        return customannotationView;
    }
    else
    {
        annotationView.annotation = self;
        annotationView.image = [UIImage imageNamed: @"walking"];
    }
    return annotationView;
}

@end
