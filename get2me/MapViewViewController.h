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

@interface MapViewViewController : UIViewController  <MKMapViewDelegate, CLLocationManagerDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end