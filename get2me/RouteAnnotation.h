//
//  GMRouteAnnotation.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GMStep.h"

typedef enum RouteAnnotationType {
	RouteAnnotationTypeStart,
	RouteAnnotationTypeEnd,
	RouteAnnotationTypeWayPoint,
} RouteAnnotationType;

@interface RouteAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	RouteAnnotationType annotationType;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) RouteAnnotationType annotationType;
@property (nonatomic) GMStep *step;
@property (nonatomic) BOOL myStep;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
				   title:(NSString *)aTitle
                subtitle: (NSString *)aSubtitle
		  annotationType:(RouteAnnotationType)type;

@end
