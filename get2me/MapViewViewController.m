//
//  MapViewViewController.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/16/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "MapViewViewController.h"

typedef void (^PerformAfterAcquiringLocationSuccess)(CLLocationCoordinate2D);
typedef void (^PerformAfterAcquiringLocationError)(NSError *);

@interface MapViewViewController ()

@end

@implementation MapViewViewController
{
    PerformAfterAcquiringLocationSuccess _afterLocationSuccess;
    PerformAfterAcquiringLocationError _afterLocationError;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] init];

    return pinAnnotationView;
}

- (void)performAfterAcquiringLocation:(PerformAfterAcquiringLocationSuccess)success error:(PerformAfterAcquiringLocationError)error
{
    if (self.mapView.userLocation != nil) {
        if (success)
            success(self.mapView.userLocation.coordinate);
        return;
    }
    
    _afterLocationSuccess = [success copy];
    _afterLocationError = [error copy];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // If we are waiting on a user location, call the block
    PerformAfterAcquiringLocationSuccess callback = _afterLocationSuccess;
    _afterLocationError = nil;
    _afterLocationSuccess = nil;
    
    if (callback)
        callback(userLocation.coordinate);
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    // If we are waiting on a user location, inform the block of the error
    PerformAfterAcquiringLocationError callback = _afterLocationError;
    _afterLocationError = nil;
    _afterLocationSuccess = nil;
    
    if (callback)
        callback(error);
}

@end
