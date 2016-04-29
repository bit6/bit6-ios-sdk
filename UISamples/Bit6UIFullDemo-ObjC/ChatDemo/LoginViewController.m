//
//  LoginViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "LoginViewController.h"
#import "DemoContactSource.h"

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

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    Bit6Address *userIdentity = [Bit6Address addressWithUsername:username];
    [Bit6.session loginWithUserIdentity:userIdentity password:password completionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Failed" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)signUpWithUsername:(NSString*)username password:(NSString*)password
{
    Bit6Address *userIdentity = [Bit6Address addressWithUsername:username];
    [Bit6.session signUpWithUserIdentity:userIdentity password:password completionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SignUp Failed" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginCompleted"]) {
        //setting the contact source for Bit6UI
        [BXU setContactSource:[DemoContactSource new]];
    }
}

@end
