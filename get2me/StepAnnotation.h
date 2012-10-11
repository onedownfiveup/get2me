//
//  StepAnnotation.h
//  get2me
//
//  Created by Constantinos Mavromoustakos on 10/5/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "Get2meAnnotation.h"

@interface StepAnnotation : Get2meAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
				   title:(NSString *)aTitle
                subtitle: (NSString *)aSubtitle;

-(MKAnnotationView *)viewForAnnotationWithMapView: (MKMapView *)mapview;
@end
