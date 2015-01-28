//
//  LoginViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UIAlertViewDelegate>
{
    BOOL _doingLogin;
}

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated
{
    if (Bit6.session.authenticated) {
        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
    }
    [super viewWillAppear:animated];
}

- (IBAction)touchedLoginBarButton:(id)sender {
    _doingLogin = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter your username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

- (IBAction)touchedSignUpButton:(id)sender {
    _doingLogin = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up" message:@"Enter an username and a password for the new account" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        if (_doingLogin) {
            [self loginWithUsername:username password:password];
        }
        else {
            [self signUpWithUsername:username password:password];
        }
    }
}

- (void) loginWithUsername:(NSString*)username password:(NSString*)password
{
    Bit6Address *userIdentity = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    [Bit6.session loginWithUserIdentity:userIdentity password:password completionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void) signUpWithUsername:(NSString*)username password:(NSString*)password
{
    Bit6Address *userIdentity = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    [Bit6.session signUpWithUserIdentity:userIdentity password:password completionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"SignUp Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
