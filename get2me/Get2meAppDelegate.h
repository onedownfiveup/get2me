//
//  RailzbizAppDelegate.h
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/12/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface Get2meAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) RKObjectManager *objectManager;

@end
