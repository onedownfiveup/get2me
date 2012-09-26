#import "TransitShape.h"

#define REALLOC_SIZE 10

@implementation TransitShape {
    CLLocationCoordinate2D *_coordinates;
    NSUInteger _coordinatesCount;
    NSUInteger _coordinatesAvailableSpace;
}

@synthesize coordinates = _coordinates, coordinatesCount = _coordinatesCount;

- (void)dealloc
{
    if (_coordinates)
        free(_coordinates);
}

- (void)addCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_coordinates == nil) {
        _coordinatesAvailableSpace = REALLOC_SIZE;
        _coordinates = (CLLocationCoordinate2D *)malloc(_coordinatesAvailableSpace * sizeof(CLLocationCoordinate2D));
    } else if (_coordinatesCount == _coordinatesAvailableSpace) {
        _coordinatesAvailableSpace += REALLOC_SIZE;
        _coordinates = (CLLocationCoordinate2D *)realloc(_coordinates, _coordinatesAvailableSpace * sizeof(CLLocationCoordinate2D));
    }
    
    _coordinates[_coordinatesCount] = coordinate;
    _coordinatesCount++;
}

@end
