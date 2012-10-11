//
//  MapViewViewController.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/16/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "MapViewViewController.h"
#import "CurrentUser.h"
#import "TransitShape.h"
#import "Direction.h"
#import "UserSearchContainerViewController.h"
#import "DirectionInvitesViewController.h"
#import "RouteAnnotation.h"
#import "StepAnnotation.h"
#import "UIColor+Extensions.h"
#import "Get2meAnnotation.h"

@implementation MapViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.googleDirections) {
        self.googleDirections = [[NSMutableArray alloc] init];
    }

    self.directionInstructionView.hidden = YES;
    self.routeOverlayView = [[RouteOverlayMapView alloc] initWithMapView: self.mapView];
    self.mapView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
    
    [self loadDirections];

}

-(void)loadDirections
{
    // send push notification to users along with storing it on server.
    User *currentUser =  [CurrentUser sharedInstance].user;
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    NSString *directionsPath = [NSString stringWithFormat: @"/api/v1/users/%@/directions.json?auth_token=%@",
                                currentUser.userId,
                                currentUser.token];
        
    [sharedManager loadObjectsAtResourcePath: directionsPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      loader.method = RKRequestMethodGET;
                                      loader.delegate = self;
                                  }];    
}

- (void)directionsDidUpdateDirections:(GMDirection *)googleDirections
{
    User *currentUser = [CurrentUser sharedInstance].user;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Overlay polylines
	NSArray *stepCoordinates = [googleDirections.googleRoute decodedPolyLine];
    NSArray *routeSteps = googleDirections.googleSteps;
    Route *route = googleDirections.route;
    
	[self.routeOverlayView setSteps:stepCoordinates];
	
    if([route.user.userId isEqualToString: currentUser.userId]) {
        [self.routeOverlayView drawAnnotationsForSteps: routeSteps];
    } else {
        // Add annotations
        RouteAnnotation *startAnnotation = [[RouteAnnotation alloc] initWithCoordinate:[[stepCoordinates objectAtIndex:0] coordinate]
                                                                                 title: @"Start"
                                                                              subtitle: nil                                                                        annotationType:AnnotationTypeStart];
        
        MKUserLocation *userLocation = [[MKUserLocation alloc] init];
        userLocation.coordinate = route.startLocation.coordinate;
        
        [self.mapView addAnnotations: [NSArray arrayWithObjects: startAnnotation, nil]];

    }

    [self.routeOverlayView drawLine];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[StepAnnotation class]]) {
        return [(StepAnnotation *)annotation viewForAnnotationWithMapView: self.mapView];
    }
    else if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation *)annotation viewForAnnotationWithMapView: self.mapView];
    }
    return nil;
}

- (IBAction)previousStep {
    NSInteger stepIndex = [self.stepAnnotations indexOfObject: self.currentSelectedStepAnnotation];
    NSInteger previsousStepAnnotationIndex = stepIndex - 1;
    
    if (previsousStepAnnotationIndex >= 0) {
        Get2meAnnotation *annotation = (RouteAnnotation *)[self.stepAnnotations objectAtIndex: previsousStepAnnotationIndex];
        MKCoordinateRegion region = [annotation focusRegion];

        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation: annotation  animated: YES];
    }

}

- (IBAction)nextStep {
    NSInteger stepIndex = [self.stepAnnotations indexOfObject: self.currentSelectedStepAnnotation];
    NSInteger nextStepAnnotationIndex = stepIndex + 1;
    
    if (nextStepAnnotationIndex < [self.stepAnnotations count]) {
        Get2meAnnotation *annotation = (Get2meAnnotation *)[self.stepAnnotations objectAtIndex: nextStepAnnotationIndex];
        
        MKCoordinateRegion region = [annotation focusRegion];
        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation: annotation animated: YES];
    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    id<MKAnnotation> annotation = view.annotation;
    
    if([annotation isKindOfClass: [Get2meAnnotation class]] && [(Get2meAnnotation *)annotation myStep]) {
        self.directionInstructionView.hidden = NO;
        self.directionInstructionsLabel.text = [annotation subtitle];
        self.currentSelectedStepAnnotation = annotation;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    self.directionInstructionView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	self.routeOverlayView.hidden = NO;
	[self.routeOverlayView setNeedsDisplay];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
    polylineView.lineWidth = 0;
    
    UIColor *randomColor = [UIColor randomColorWithAlphaComponent: 0.5];
    polylineView.strokeColor = randomColor;
    return polylineView;
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([objects count] > 0) {
        self.direction = [objects objectAtIndex: 0];
        for (Route *route in self.direction.routes) {
            if ([route isAccepted]) {
                self.currentRoute = route;
                GMDirection *googleDirection = [[GMDirection alloc] init];
                
                googleDirection.delegate = self;
                [googleDirection googleRouteForRoute: route];
                [self.googleDirections addObject: googleDirection];
            }
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Value of error is %@", objectLoader.response.bodyAsString);
}

@end
