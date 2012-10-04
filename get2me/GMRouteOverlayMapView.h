//
//  GMRouteOverlayMapView.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GMStep.h"

@interface GMRouteOverlayMapView : MKOverlayView {
	MKMapView *inMapView;
	NSArray *steps;
	UIColor *lineColor;
}

- (id)initWithMapView:(MKMapView *)mapView;
- (void)drawLine;
- (void)drawAnnotationsForSteps: (NSArray *)routeSteps;

@property (nonatomic, retain) MKMapView *inMapView;
@property (nonatomic, retain) NSArray *steps;
@property (nonatomic, retain) UIColor *lineColor; 
@end
