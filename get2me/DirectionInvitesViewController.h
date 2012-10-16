//
//  DirectionInvitesViewController.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/26/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface DirectionInvitesViewController : UITableViewController <RKObjectLoaderDelegate>
@property (nonatomic, retain) NSArray *routes;
@property (strong, nonatomic) IBOutlet UISwitch *trackingSwitch;

@end
