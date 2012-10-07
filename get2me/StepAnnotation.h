//
//  StepAnnotation.h
//  get2me
//
//  Created by Constantinos Mavromoustakos on 10/5/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GMStep.h"

@interface StepAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) GMStep *step;
@property (nonatomic) BOOL myStep;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
				   title:(NSString *)aTitle
                subtitle: (NSString *)aSubtitle;

@end
