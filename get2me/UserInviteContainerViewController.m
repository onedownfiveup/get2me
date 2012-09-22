//
//  UserInviteContainerViewController.m
//  get2me
//
//  Created by Constantinos Mavromoustakos on 9/20/12.
//  Copyright (c) 2012 Railzbiz. All rights reserved.
//

#import "UserInviteContainerViewController.h"

@interface UserInviteContainerViewController ()

@end

@implementation UserInviteContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self.userInviteViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UserInviteViewController *) userInviteViewController
{
   
    NSLog(@"Something");
    
    NSUInteger idx = [self.childViewControllers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj isKindOfClass: [UserInviteViewController class]]);
    }];
    
    return [self.childViewControllers objectAtIndex: idx];
}


@end
