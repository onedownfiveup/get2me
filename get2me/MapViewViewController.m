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

typedef void (^PerformAfterAcquiringLocationSuccess)(CLLocationCoordinate2D);
typedef void (^PerformAfterAcquiringLocationError)(NSError *);

@interface MapViewViewController ()

@end

@implementation MapViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
//    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
    
    [self loadDirections];
    diretions = [GMDirections sharedDirections];
	diretions.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

-(NSMutableArray *)decodePolyLine: (NSString *)encString
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encString length]];
    
    [encoded appendString:encString];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
        polylineView.lineWidth = 0;
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        return polylineView;
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([objects count] > 0) {
        Direction *direction = [objects objectAtIndex: 0];
        NSArray *routes = direction.routes;
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Value of error is %@", objectLoader.response.bodyAsString);
}

-(void) testSelector
{
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(40.746040, -73.982190);
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake(40.68922000000001, -73.98467000000001);
    
    MKMapPoint startMapPoint = MKMapPointForCoordinate(startCoordinate);
    MKMapPoint endMapPoint = MKMapPointForCoordinate(endCoordinate);
    
    NSUInteger closestStartPointOffset = 0;
    CLLocationDistance closestStartDistance = INFINITY;
    
    NSUInteger closestEndPointOffset = 0;
    CLLocationDistance closestEndDistance = INFINITY;
    
    TransitShape *transitShape = [[TransitShape alloc] init];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.746040, -73.982190)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.736560, -73.98907000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.736560, -73.98907000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.73652000000001, -73.98896000000002)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.73652000000001, -73.98896000000002)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.734420, -73.98990000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.734420, -73.98990000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.72985000000001, -73.990690)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.72985000000001, -73.990690)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.72712000000001, -73.99162000000001 )];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.72712000000001, -73.99162000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.716050, -73.99626000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.716050, -73.99626000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.715890, -73.99610000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.715890, -73.99610000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.699640, -73.986580)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.699640, -73.986580)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.699870, -73.98683000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.699870, -73.98683000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.69146000000001, -73.98736000000001)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.690480, -73.987870)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.690480, -73.987870)];
    [transitShape addCoordinate: CLLocationCoordinate2DMake(40.68922000000001, -73.98467000000001)];
    
    for (NSUInteger i = 0; i < transitShape.coordinatesCount; i++) {
        CLLocationCoordinate2D coordinate = transitShape.coordinates[i];
        MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
        CLLocationDistance distanceToStart = MKMetersBetweenMapPoints(mapPoint, startMapPoint);
        if (distanceToStart < closestStartDistance) {
            closestStartDistance = distanceToStart;
            closestStartPointOffset = i;
        }
        
        CLLocationDistance distanceToEnd = MKMetersBetweenMapPoints(mapPoint, endMapPoint);
        if (distanceToEnd < closestEndDistance) {
            closestEndDistance = distanceToEnd;
            closestEndPointOffset = i;
        }
    }
    
    NSMutableArray *path = [self decodePolyLine: @"blah"];
    NSInteger numberOfSteps = path.count;
    
    MKMapPoint coordinates[numberOfSteps];
    
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [path objectAtIndex:index];
        MKMapPoint coordinate = MKMapPointForCoordinate(location.coordinate);
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithPoints:coordinates count:[path count]];
    polyLine.title = @"Poop on a broom";
    [self.mapView addOverlay:polyLine];

}
@end
