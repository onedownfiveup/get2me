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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.passwordConfirmationField.delegate = self;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    
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

# pragma mark UITextFieldDelegate selectors
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
