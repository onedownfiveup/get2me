//
//  GMRouteAnnotation.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "RouteAnnotation.h"

@implementation RouteAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize annotationType;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
				   title:(NSString *)aTitle
				   subtitle:(NSString *)aSubtitle
		  annotationType:(AnnotationType)type {
	self = [super init];
	if (self != nil) {
		coordinate = coord;
		title = aTitle;
        subtitle = aSubtitle;
		annotationType = type;
	}
	return self;
}

-(MKAnnotationView *)viewForAnnotationWithMapView: (MKMapView *)mapview
{
    
    NSString* routeAnnotationIdentifier = @"routeAnnotation";
    
    MKAnnotationView* annotationView = (MKAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:routeAnnotationIdentifier];
    if (!annotationView)
    {
        // if an existing annotation view was not available, create one
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                      reuseIdentifier:routeAnnotationIdentifier];
        annotationView.canShowCallout = YES;
    }
    if ([self annotationType] == AnnotationTypeEnd) {
        annotationView.image = [UIImage imageNamed:@"target"];
    } else if ([self annotationType] == AnnotationTypeStart) {
        annotationView.image = [UIImage imageNamed:@"start_route"];
    } else if ([self annotationType] == AnnotationTypeWayPoint) {
        annotationView.image = [UIImage imageNamed:@"person_1"];
    } else
        annotationView.image = nil;
    
    return annotationView;
}
@end
