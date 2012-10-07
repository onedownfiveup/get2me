//
//  GMStep.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMStep.h"
#import "NSString+Extensions.h"

@implementation GMStep


-(NSMutableArray *)decodedPolyLine
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[self.polyline length]];
    
    [encoded appendString:self.polyline];
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

-(CLLocation *) startLocation
{
    return [[CLLocation alloc] initWithLatitude: [self.startPointLatitude doubleValue]
                                      longitude: [self.startPointLongitude doubleValue]];
}

-(CLLocation *) endLocation
{
    return [[CLLocation alloc] initWithLatitude: [self.endPointLatitude doubleValue]
                                      longitude: [self.endPointLongitude doubleValue]];
    
}

-(NSString *)stepDirections
{
    return [NSString stringWithFormat: @"%@ for %@ - %@",
     [self.descriptionHtml stringByConvertingHTMLToPlainText],
     self.distanceText,
     self.durationText];
     
}
@end
