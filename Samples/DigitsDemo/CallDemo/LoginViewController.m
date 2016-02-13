//
//  LoginViewController.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"
#import <DigitsKit/DigitsKit.h>

@interface LoginViewController ()

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
    __weak LoginViewController *__weakSelf = self;
    
    [[Digits sharedInstance] logOut];
    [[Digits sharedInstance] authenticateWithCompletion:^(DGTSession *session, NSError *error) {
        if (error == nil) {
            Digits *digits = [Digits sharedInstance];
            DGTOAuthSigning *oauthSigning = [[DGTOAuthSigning alloc] initWithAuthConfig:digits.authConfig authSession:digits.session];
            NSDictionary *authHeaders = [oauthSigning OAuthEchoHeadersToVerifyCredentials];
            
            [Bit6.session oauthForProvider:@"digits" params:authHeaders completion:^(NSDictionary *response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        [__weakSelf performSegueWithIdentifier:@"loginCompleted" sender:nil];
                    }
                    else {
                        [[[UIAlertView alloc] initWithTitle:@"SignUp Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                });
            }];
        }
    }];
}

@end
