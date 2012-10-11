//
//  GMRouteAnnotation.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "Get2meAnnotation.h"

@interface RouteAnnotation : Get2meAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
				   title:(NSString *)aTitle
                subtitle: (NSString *)aSubtitle
		  annotationType:(AnnotationType)type;

-(MKAnnotationView *)viewForAnnotationWithMapView: (MKMapView *)mapview;
@end
