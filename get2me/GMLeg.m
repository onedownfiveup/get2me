//
//  GMLeg.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/30/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "GMLeg.h"

@implementation GMLeg

- (GMStep *)stepAtIndex:(NSInteger)index {
	return [self.steps objectAtIndex:index];;
}

@end
