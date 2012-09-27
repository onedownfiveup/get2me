//
//  UserSearchContainerViewController.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/17/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "FriendsViewController.h"
#import <MapKit/MapKit.h>

@interface UserSearchContainerViewController : UIViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) FriendsViewController *friendsController;
@property (strong, nonatomic) CLLocation *destinationLocation;
@end
