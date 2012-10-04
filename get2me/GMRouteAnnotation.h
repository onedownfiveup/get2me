//
//  GMRouteAnnotation.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum GMRouteAnnotationType {
	GMRouteAnnotationTypeStart,
	GMRouteAnnotationTypeEnd,
	GMRouteAnnotationTypeWayPoint,
} GMRouteAnnotationType;

@interface GMRouteAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	GMRouteAnnotationType annotationType;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) GMRouteAnnotationType annotationType;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
				   title:(NSString *)aTitle
                subtitle: (NSString *)aSubtitle
		  annotationType:(GMRouteAnnotationType)type;

@end
