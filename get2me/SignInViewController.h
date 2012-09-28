//
//  SignInViewController.h
//  get2me
//
//  Created by Constantine Mavromoustakos on 9/15/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface SignInViewController : UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end
