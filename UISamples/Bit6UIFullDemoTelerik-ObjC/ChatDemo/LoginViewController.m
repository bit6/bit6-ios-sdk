//
//  LoginViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"
#import <EverliveSDK/EverliveSDK.h>

#warning Remember to set your Telerik key
#define TELERIK_KEY (@"TELERIK_KEY")

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:129/255.0 blue:206/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSAssert(![TELERIK_KEY isEqualToString:@"TELERIK_KEY"], @"[Telerik SDK]: Setup your Telerik api key.");
    
    [super viewWillAppear:animated];
    
    if (Bit6.session.authenticated) {
        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
    }
}

- (IBAction)touchedLoginBarButton:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login" message:@"Enter your username and password" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *userTextField = alert.textFields[0];
                                                NSString *user = userTextField.text;
                                                UITextField *passTextField = alert.textFields[1];
                                                NSString *pass = passTextField.text;
                                                [self loginWithUsername:user password:pass];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)touchedSignUpButton:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Up" message:@"Enter your username and password" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *userTextField = alert.textFields[0];
                                                NSString *user = userTextField.text;
                                                UITextField *passTextField = alert.textFields[1];
                                                NSString *pass = passTextField.text;
                                                [self signUpWithUsername:user password:pass];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    [EVUser logOut];
    [EVUser loginWithUsername:username password:password block:^(EVUser *user, NSError *error) {
        if (!error) {
            NSString *urlString = [NSString stringWithFormat:@"http://api.everlive.com/v1/%@/Functions/bit6_auth?access_token=%@",TELERIK_KEY,user.accessToken];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *resp = [NSData dataWithContentsOfURL:url];
            if (resp) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:resp options:0 error:nil];
                NSString *token = json[@"Result"];
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
            [[[UIAlertView alloc] initWithTitle:@"Telerik Login Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)signUpWithUsername:(NSString*)username password:(NSString*)password
{
    [EVUser logOut];
    EVUser *user = [EVUser new];
    user.username = username;
    user.password = password;
    
    [user signUp:^(EVUser *user, NSError *error) {
        if (!error) {
            NSString *urlString = [NSString stringWithFormat:@"http://api.everlive.com/v1/%@/Functions/bit6_auth?access_token=%@",TELERIK_KEY,user.accessToken];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *resp = [NSData dataWithContentsOfURL:url];
            if (resp) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:resp options:0 error:nil];
                NSString *token = json[@"Result"];
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
            [[[UIAlertView alloc] initWithTitle:@"Telerik SignUp Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end