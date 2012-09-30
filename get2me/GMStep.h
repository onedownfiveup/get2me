//
//  GMStep.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GMStep : NSObject {
	NSDictionary *dictionaryRepresentation;
	NSString     *polyline;
	NSString     *descriptionHtml;
	NSDictionary *distance;
	NSDictionary *duration;
}

@property (nonatomic, retain, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, retain, readonly) NSString     *polyline;
@property (nonatomic, retain, readonly) NSString     *descriptionHtml;
@property (nonatomic, retain, readonly) NSDictionary *distance;
@property (nonatomic, retain, readonly) NSDictionary *duration;

@end
