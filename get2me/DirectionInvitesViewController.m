//
//  DirectionInvitesViewController.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/26/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "DirectionInvitesViewController.h"
#import "CurrentUser.h"

@interface DirectionInvitesViewController ()

@end

@implementation DirectionInvitesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadInvites];
    
}

-(void)loadInvites
{
    // send push notification to users along with storing it on server.
    User *currentUser =  [CurrentUser sharedInstance].user;
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    NSString *directionsPath = [NSString stringWithFormat: @"/api/v1/users/%@/routes.json?state=pending&auth_token=%@",
                                currentUser.userId,
                                currentUser.token];
    
    [sharedManager loadObjectsAtResourcePath: directionsPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      loader.method = RKRequestMethodGET;
                                      loader.delegate = self;
                                  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"routeInviteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - Restkit delegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
        
    self.routes = objects;
    [self.tableView reloadData];
}

@end
