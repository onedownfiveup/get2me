//
//  CreateAccountViewController.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/15/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface CreateAccountViewController : UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmationField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;

@end
