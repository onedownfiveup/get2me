//
//  FriendsViewController.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/17/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "FriendsViewController.h"
#import "CurrentUser.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    User *currentUser =  [CurrentUser sharedInstance].user;
    
    if (!self.filteredFriends)
        self.filteredFriends = [[NSMutableArray alloc] init];

    if(!self.selectedFriends)
        self.selectedFriends = [[NSMutableArray alloc] init];
 
    NSString *userSessionPath = [NSString stringWithFormat: @"/api/v1/users/%@/friends.json?auth_token=%@", currentUser.userId, currentUser.token];
    
    [sharedManager loadObjectsAtResourcePath: userSessionPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      loader.method= RKRequestMethodGET;
                                      loader.delegate = self;
                                  }];

    self.tableView.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelAddingFriends:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self friendList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    User *friend = [[self friendList] objectAtIndex: indexPath.row];
    
    UILabel *userNameLabel = (UILabel* )[cell viewWithTag: 1];
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];

    UILabel *emailLabel = (UILabel* )[cell viewWithTag: 2];
    emailLabel.text = [NSString stringWithFormat:@"%@", friend.email];
    
    if([self.selectedFriends containsObject: friend])
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    return cell;
}


-(NSArray *) friendList
{
    if (self.searchTerm) {
        return self.filteredFriends;
    } else {
        return self.friends;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *friend = [[self friendList] objectAtIndex: indexPath.row];
    [self.selectedFriends removeObject: friend];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *friend = [[self friendList] objectAtIndex: indexPath.row];
    
    if (![self.selectedFriends containsObject: friend]) {
        [self.selectedFriends addObject: friend];
    }
}

#pragma mark - Restkit delegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    self.friends = objects;
    [self.tableView reloadData];
}

# pragma mark - SearchBar delegate
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        self.searchTerm = searchText;
    } else {
        self.searchTerm = nil;
    }
    
    [self filterObjectsForSearchText: searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchTerm = nil;
    [self.tableView reloadData];
}

# pragma mark - Actions
-(void) filterObjectsForSearchText: (NSString *)searchText
{
    [self.filteredFriends removeAllObjects];
    
    for (User *friend in self.friends)
	{
        if (([friend.email rangeOfString: searchText].location != NSNotFound))
        {
            [self.filteredFriends addObject:friend];
        }
    }
    [self.tableView reloadData];
}
@end
