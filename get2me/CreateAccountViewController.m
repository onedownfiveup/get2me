//
//  CreateAccountViewController.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/15/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "CurrentUser.h"

@implementation CreateAccountViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPopup{
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)createUser {

    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass: [User class]];
    [userMapping mapKeyPath:@"_id" toAttribute:@"userId"];
    [userMapping mapKeyPath:@"token" toAttribute:@"token"];
    
    [sharedManager.mappingProvider setObjectMapping:userMapping forKeyPath: @"user"];
    
    NSString *usersPath = [NSString stringWithFormat: @"/api/v1/users.json"];
    
    [sharedManager loadObjectsAtResourcePath: usersPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      RKParams *params= [RKParams params];
                                      [params setValue: self.usernameField.text
                                              forParam: @"user[email]"];
                                      [params setValue: self.passwordField.text
                                              forParam: @"user[password]"];
                                      [params setValue: self.firstNameField.text
                                              forParam: @"user[first_name]"];
                                      [params setValue: self.lastNameField.text
                                              forParam: @"user[last_name]"];
                                      [params setValue: self.passwordConfirmationField.text
                                              forParam: @"user[password_confirmation]"];
                                      loader.params = params;
                                      loader.method= RKRequestMethodPOST;
                                      loader.delegate = self;
                                  }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"Error logging in!"
                          message: @"Invalid username/password please try again"
                          delegate:nil
                          cancelButtonTitle:@"Try again"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [CurrentUser sharedInstance].user = [objects objectAtIndex: 0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentUserStateChange" object:self];
}
@end
