//
//  LoginViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"
#import <DigitsKit/DigitsKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:129/255.0 blue:206/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

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