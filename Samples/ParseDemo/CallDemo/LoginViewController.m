//
//  LoginViewController.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

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
    [PFUser logOut];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            NSError *err = nil;
            NSString *token = [PFCloud callFunction:@"bit6_auth" withParameters:nil error:&err];
            if (!err) {
                [Bit6.session authWithExternalToken:token completionHandler:^(NSDictionary *response, NSError *error) {
                    if (!error) {
                        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
                    }
                    else {
                        [[[UIAlertView alloc] initWithTitle:@"Failed to authenticate with Bit6" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Failed to get external token" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Parse Login Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void) signUpWithUsername:(NSString*)username password:(NSString*)password
{
    [PFUser logOut];
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSError *err = nil;
            NSString *token = [PFCloud callFunction:@"bit6_auth" withParameters:nil error:&err];
            if (!err) {
                [Bit6.session authWithExternalToken:token completionHandler:^(NSDictionary *response, NSError *error) {
                    if (!error) {
                        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
                    }
                    else {
                        [[[UIAlertView alloc] initWithTitle:@"Failed to authenticate with Bit6" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Failed to get external token" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Parse SignUp Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
