//
//  Route.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/19/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Route : NSObject

+(void) loadRestkitMappingsWithDirectionMapping: (RKObjectMapping *) directionMapping;

@end
