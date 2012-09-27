//
//  UserSearchContainerViewController.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/17/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "UserSearchContainerViewController.h"
#import "CurrentUser.h"
#import "Direction.h"

@interface UserSearchContainerViewController ()

@end

@implementation UserSearchContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.delegate = self.friendsController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissFriendSearch:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)sendDirections:(id)sender {
    if ([self.friendsController.selectedFriends count] <= 0) {
        UIAlertView* alert =  [[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message: @"You must select at least one friend to send directions to!"
                                                        delegate: self
                                               cancelButtonTitle: @"Cancel"
                                               otherButtonTitles: nil, nil];
        [alert show];
        return;
    }
    // send push notification to users along with storing it on server.
    User *currentUser =  [CurrentUser sharedInstance].user;
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    NSString *directionsPath = [NSString stringWithFormat: @"/api/v1/users/%@/directions.json", currentUser.userId];

    NSArray *selectedFriends = self.friendsController.selectedFriends;
    NSArray *selectedFriendIds = [selectedFriends valueForKeyPath:@"userId"];
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", self.destinationLocation.coordinate.latitude];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", self.destinationLocation.coordinate.longitude];
    
    [sharedManager loadObjectsAtResourcePath: directionsPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      RKParams *params= [RKParams params];
                                      loader.params = params;
                                      [params setValue: currentUser.token
                                              forParam: @"auth_token"];
                                      [params setValue: [[selectedFriendIds valueForKey:@"description"] componentsJoinedByString:@","]
                                              forParam: @"direction[friend_ids]"];
                                      [params setValue: latitude
                                              forParam: @"direction[end_coordinates][latitude]"];
                                      [params setValue: longitude
                                              forParam: @"direction[end_coordinates][longitude]"];
                                      
                                      loader.method = RKRequestMethodPOST;
                                      loader.delegate = self;
                                  }];
}

-(FriendsViewController *) friendsController
{
    NSUInteger idx = [self.childViewControllers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj isKindOfClass: [FriendsViewController class]]);
    }];
    
    return [self.childViewControllers objectAtIndex: idx];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

#pragma mark - Restkit delegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    Direction *direction = [objects objectAtIndex: 0];
    User *user = direction.user;
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

@end
