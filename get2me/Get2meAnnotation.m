//
//  Get2meAnnotation.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 10/10/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "Get2meAnnotation.h"

@implementation Get2meAnnotation

-(MKCoordinateRegion) focusRegion
{
    MKCoordinateRegion region;
    
    region.center.latitude     = self.coordinate.latitude;
    region.center.longitude    = self.coordinate.longitude;
    region.span.latitudeDelta  = .001f;
    region.span.longitudeDelta = .001f;
    
    return region;
}

@end
