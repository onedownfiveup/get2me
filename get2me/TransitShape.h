
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TransitShape : NSObject

@property (readonly) CLLocationCoordinate2D *coordinates;
@property (readonly) NSUInteger coordinatesCount;
- (void)addCoordinate:(CLLocationCoordinate2D)coordinate;

@end
