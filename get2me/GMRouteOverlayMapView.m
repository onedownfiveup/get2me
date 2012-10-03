//
//  GMRouteOverlayMapView.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMRouteOverlayMapView.h"

@implementation GMRouteOverlayMapView

@synthesize inMapView;
@synthesize steps;
@synthesize lineColor; 

- (id)initWithMapView:(MKMapView *)mapView {
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f, mapView.frame.size.width, mapView.frame.size.height)];
	if (self != nil) {
		self.inMapView = mapView;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		[self.inMapView addSubview:self];
	}
	
	return self;
}

- (void)drawLine {
    NSInteger stepCount = [self.steps count];
    CLLocationCoordinate2D coords[stepCount];
    CLLocationCoordinate2D *p = coords;
    
    for (CLLocation *loc in self.steps) {
        p->latitude = loc.coordinate.latitude, p->longitude = loc.coordinate.longitude;
        p++;
    }
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:stepCount];
    [self.inMapView addOverlay:line];
}

- (void)setSteps:(NSArray *)stepPoints {
	if (steps != stepPoints) {
		steps = stepPoints;
		
		CLLocationDegrees maxLat = -90.0f;
		CLLocationDegrees maxLon = -180.0f;
		CLLocationDegrees minLat = 90.0f;
		CLLocationDegrees minLon = 180.0f;
		
		for (int i = 0; i < self.steps.count; i++) {
			CLLocation *currentLocation = [self.steps objectAtIndex:i];
			if(currentLocation.coordinate.latitude > maxLat) {
				maxLat = currentLocation.coordinate.latitude;
			}
			if(currentLocation.coordinate.latitude < minLat) {
				minLat = currentLocation.coordinate.latitude;
			}
			if(currentLocation.coordinate.longitude > maxLon) {
				maxLon = currentLocation.coordinate.longitude;
			}
			if(currentLocation.coordinate.longitude < minLon) {
				minLon = currentLocation.coordinate.longitude;
			}
		}
		
		MKCoordinateRegion region;
		region.center.latitude     = (maxLat + minLat) / 2;
		region.center.longitude    = (maxLon + minLon) / 2;
		region.span.latitudeDelta  = maxLat - minLat;
		region.span.longitudeDelta = maxLon - minLon;
		
		[self.inMapView setRegion:region animated:YES];
	}
}

@end
