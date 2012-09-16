//
//  User.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/15/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *token;

@end
