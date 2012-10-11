//
//  Get2meAnnotation.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 10/10/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GMStep.h"

typedef enum AnnotationType {
	AnnotationTypeStart,
	AnnotationTypeEnd,
	AnnotationTypeWayPoint,
} AnnotationType;

@interface Get2meAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) AnnotationType annotationType;
@property (nonatomic) GMStep *step;
@property (nonatomic) BOOL myStep;

-(MKCoordinateRegion) focusRegion;

@end
