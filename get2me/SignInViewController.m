//
//  SignInViewController.m
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/15/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "SignInViewController.h"
#import "CurrentUser.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

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

- (IBAction)dismissPopup {
    [self dismissViewControllerAnimated:YES completion: nil];
 }

- (IBAction)signUserIn {
    RKObjectManager *sharedManager = [RKObjectManager sharedManager];
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass: [User class]];

    [userMapping mapKeyPath:@"_id" toAttribute:@"userId"];
    [userMapping mapKeyPath:@"token" toAttribute:@"token"];

    [sharedManager.mappingProvider setObjectMapping:userMapping forKeyPath: @"user"];
    
    NSString *userSessionPath = [NSString stringWithFormat: @"/api/v1/user_sessions.json"];
    
    [sharedManager loadObjectsAtResourcePath: userSessionPath
                                  usingBlock: ^(RKObjectLoader *loader) {
                                      RKParams *params= [RKParams params];
                                      [params setValue: self.usernameField.text forParam: @"email"];
                                      [params setValue: self.passwordField.text forParam: @"password"];
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
