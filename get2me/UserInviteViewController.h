//
//  UserInviteViewController.h
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/20/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface UserInviteViewController :  UITableViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) NSArray *users;
@property  (nonatomic, retain) NSMutableArray *selectedUsers;

@end
