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

typedef void (^PerformAfterAcquiringLocationSuccess)(CLLocationCoordinate2D);
typedef void (^PerformAfterAcquiringLocationError)(NSError *);

@interface MapViewViewController ()

@end

@implementation MapViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.directions) {
        self.directions = [[NSMutableArray alloc] init];
    }
    self.directionInstructionView.hidden = YES;
    self.routeOverlayView = [[RouteOverlayMapView alloc] initWithMapView: self.mapView];
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
    
    [self loadDirections];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)directionsDidUpdateDirections:(GMDirections *)googleDirections
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
                                                                              subtitle: @"This is a ridiculously long string that can not possibly fit on one line. Please do not cut it off."
                                                                        annotationType:RouteAnnotationTypeStart];
        
        RouteAnnotation *endAnnotation = [[RouteAnnotation alloc] initWithCoordinate:[[stepCoordinates lastObject] coordinate]
                                                                               title: [route titleForAnnotation]
                                                                            subtitle: @"Yeah bitches"
                                                                      annotationType:RouteAnnotationTypeEnd];
        MKUserLocation *userLocation = [[MKUserLocation alloc] init];
        userLocation.coordinate = route.startLocation.coordinate;
        
        [self.mapView addAnnotations: [NSArray arrayWithObjects: startAnnotation, endAnnotation, nil]];

    }

    [self.routeOverlayView drawLine];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[StepAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* stepAnnotationIdentifier = @"stepAnnotation";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:stepAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:stepAnnotationIdentifier];

            UIImage *directionImage = [UIImage imageNamed: @"directions_icon"];
            customPinView.image = directionImage;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
                        
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
            pinView.image = [UIImage imageNamed: @"directions_icon"];
        }
        return pinView;
    }
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        NSString* routeAnnotationIdentifier = @"routeAnnotation";
        
        MKPinAnnotationView* pinView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:routeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:routeAnnotationIdentifier];
            
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            if ([(RouteAnnotation *)annotation annotationType] == RouteAnnotationTypeStart) {
                customPinView.pinColor = MKPinAnnotationColorGreen;
            } else if ([(RouteAnnotation *)annotation annotationType] == RouteAnnotationTypeEnd) {
                customPinView.pinColor = MKPinAnnotationColorRed;
            } else {
                customPinView.pinColor = MKPinAnnotationColorPurple;
            }

            return customPinView;
        }
        if ([(RouteAnnotation *)annotation annotationType] == RouteAnnotationTypeStart) {
            pinView.pinColor = MKPinAnnotationColorGreen;
        } else if ([(RouteAnnotation *)annotation annotationType] == RouteAnnotationTypeEnd) {
            pinView.pinColor = MKPinAnnotationColorRed;
        } else {
            pinView.pinColor = MKPinAnnotationColorPurple;
        }


        return pinView;
    }
    return nil;
}

- (IBAction)previousStep {
    NSInteger stepIndex = [self.stepAnnotations indexOfObject: self.currentSelectedStepAnnotation];
    NSInteger previsousStepAnnotationIndex = stepIndex - 1;
    
    if (previsousStepAnnotationIndex >= 0) {
        id<MKAnnotation> annotation = (RouteAnnotation *)[self.stepAnnotations objectAtIndex: previsousStepAnnotationIndex];
        
        MKCoordinateRegion region;
        
        region.center.latitude     = annotation.coordinate.latitude;
        region.center.longitude    = annotation.coordinate.longitude;
        region.span.latitudeDelta  = .001;
		region.span.longitudeDelta = .001;

        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation: annotation  animated: YES];
    }

}

- (IBAction)nextStep {
    NSInteger stepIndex = [self.stepAnnotations indexOfObject: self.currentSelectedStepAnnotation];
    NSInteger nextStepAnnotationIndex = stepIndex + 1;
    
    if (nextStepAnnotationIndex < [self.stepAnnotations count]) {
        id<MKAnnotation> annotation = (RouteAnnotation *)[self.stepAnnotations objectAtIndex: nextStepAnnotationIndex];

        MKCoordinateRegion region;
        
        region.center.latitude     = annotation.coordinate.latitude;
        region.center.longitude    = annotation.coordinate.longitude;
        region.span.latitudeDelta  = .001f;
		region.span.longitudeDelta = .001f;
        
        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation: annotation animated: YES];
    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    id<MKAnnotation> annotation = view.annotation;
    
    self.directionInstructionView.hidden = NO;
    self.directionInstructionsLabel.text = [annotation subtitle];

    if([(StepAnnotation *)annotation myStep]) {
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
    NSArray *routes;

    if ([objects count] > 0) {
        NSLog(@"Routes Json is %@", objectLoader.response.bodyAsString );
        Direction *direction = [objects objectAtIndex: 0];
        routes = direction.routes;
    }

    for (Route *route in routes) {
        if ([route isAccepted]) {
            self.currentRoute = route;
            GMDirections *direction = [[GMDirections alloc] init];
            
            direction.delegate = self;
            [self.directions addObject: direction];

            [direction googleRouteForRoute: route];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Value of error is %@", objectLoader.response.bodyAsString);
}

@end
