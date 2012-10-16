//
//  DirectionInvitesViewController.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/26/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "DirectionInvitesViewController.h"
#import "CurrentUser.h"
#import "Route.h"

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
    
    cell.tag = indexPath.row;
    // Configure the cell...
    
    return cell;
}

#pragma mark - Restkit delegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
        
    self.routes = objects;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion: nil];

}

- (IBAction)acceptInvite:(UIButton *)sender {
    CLLocation *currentLocation = [CurrentUser sharedInstance].currentLocation;
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSString *trackingSwitchState = [self trackingSwitchStateFor: (UITableViewCell *)sender.superview.superview];
    

    RKParams *params = [RKParams params];
    [params setValue: @"true" forParam: @"route[accept]"];
    [params setValue: latitude forParam: @"route[start_coordinates][latitude]"];
    [params setValue: longitude forParam: @"route[start_coordinates][longitude]"];
    [params setValue: trackingSwitchState forParam: @"route[allow_tracking]"];    
    
    [self sendUpdateForRouteWithParams: params andButtonPressed: sender];
}

-(NSString *) trackingSwitchStateFor: (UITableViewCell *) currentClickCell
{
    UISwitch *trackSwitch = (UISwitch *)[currentClickCell viewWithTag: 10];
    
    if (trackSwitch.on) {
        return @"true";
    } else {
        return @"false";
    }
}

- (IBAction)rejectInvite:(UIButton *)sender {
    RKParams *params= [RKParams params];
    [params setValue: @"true" forParam: @"route[reject]"];
    [self sendUpdateForRouteWithParams: params andButtonPressed: sender];    
}

-(void) sendUpdateForRouteWithParams: (RKParams *) params andButtonPressed: (UIButton *) button
{
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Route *route = [self.routes objectAtIndex: indexPath.row];
    
    User *currentUser =  [CurrentUser sharedInstance].user;
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    NSString *directionsPath = [NSString stringWithFormat: @"/api/v1/users/%@/routes/%@.json",
                                currentUser.userId,
                                route.routeId];
    
    [sharedManager loadObjectsAtResourcePath: directionsPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      [params setValue: currentUser.token forParam: @"auth_token"];
                                      loader.params = params;
                                      loader.method = RKRequestMethodPUT;
                                      loader.delegate = self;
                                  }];
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}
@end
