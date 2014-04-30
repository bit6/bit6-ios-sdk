//
//  LoginViewController.m
//  Test
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated
{
    if ([Bit6Session isConnected]) {
        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
    }
    else {
        [self.usernameTextField becomeFirstResponder];
    }
    [super viewWillAppear:animated];
}

- (IBAction)touchedLoginBarButton:(id)sender {
    Bit6Address *userIdentity = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME value:self.usernameTextField.text];
    [Bit6Session loginWithUserIdentity:userIdentity password:self.passTextField.text completionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)touchedSignUpButton:(id)sender {
    Bit6Address *userIdentity = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME value:self.usernameTextField.text];
    [Bit6Session signUpWithUserIdentity:userIdentity password:self.passTextField.text completionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"SignUp Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
