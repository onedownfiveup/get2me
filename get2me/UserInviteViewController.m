//
//  UserInviteViewController.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/20/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "UserInviteViewController.h"
#import "CurrentUser.h"

@interface UserInviteViewController ()

@end

@implementation UserInviteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.selectedUsers) {
        self.selectedUsers = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    User *currentUser = [CurrentUser sharedInstance].user;
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    
    NSString *userSessionPath = [NSString stringWithFormat: @"/api/v1/users.json?auth_token=%@&search_term=%@",
                                 currentUser.token,
                                 searchBar.text];
    
    [sharedManager loadObjectsAtResourcePath: userSessionPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      loader.method = RKRequestMethodGET;
                                      loader.delegate = self;
                                  }];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [[self users] objectAtIndex: indexPath.row];
    
    if([self.selectedUsers containsObject: user]) {
        return 111.0;
    } else {
        return 59.0;        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    User *user = [[self users] objectAtIndex: indexPath.row];

    if([self.selectedUsers containsObject: user]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        CellIdentifier = @"inviteUserCell";
    } else {
        CellIdentifier = @"friendCell";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *userNameLabel = (UILabel* )[cell viewWithTag: 1];
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    UILabel *emailLabel = (UILabel* )[cell viewWithTag: 2];
    emailLabel.text = [NSString stringWithFormat:@"%@", user.email];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *friend = [[self users] objectAtIndex: indexPath.row];
    
    if (![self.selectedUsers containsObject: friend]) {
        [self.selectedUsers addObject: friend];
    }
    [self.tableView reloadData];
}

#pragma mark - Restkit delegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
    self.users = objects;
    [self.tableView reloadData];
}


@end
