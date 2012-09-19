//
//  FriendsViewController.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/17/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface FriendsViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) NSMutableArray *filteredFriends;
@property (nonatomic, retain) NSMutableArray *selectedFriends;
@property (nonatomic, retain) NSString *searchTerm;

@end
