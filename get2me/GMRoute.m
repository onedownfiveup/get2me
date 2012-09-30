//
//  GMRoute.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "GMRoute.h"

@implementation GMRoute

- (GMLeg *)legAtIndex:(NSInteger)index
{
	return [self.legs objectAtIndex:index];;
}

@end
