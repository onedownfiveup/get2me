//
//  MapViewViewController.h
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/16/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <RestKit/RestKit.h>
#import "GMDirection.h"
#import "RouteOverlayMapView.h"
#import "Route.h"
#import "Direction.h"
#import "StepAnnotation.h"

@interface MapViewViewController : UIViewController  <MKMapViewDelegate, RKObjectLoaderDelegate, GMDirectionsDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, retain)    Route *currentRoute;
@property (strong, retain)    Direction *direction;
@property (strong, retain)    NSMutableArray *googleDirections;
@property (nonatomic, retain) RouteOverlayMapView *routeOverlayView;
@property (strong, nonatomic) IBOutlet UIView *directionInstructionView;
@property (strong, nonatomic) IBOutlet UILabel *directionInstructionsLabel;
@property (nonatomic, retain) StepAnnotation *currentSelectedStepAnnotation;
@property (nonatomic, retain) NSArray *stepAnnotations;

@end