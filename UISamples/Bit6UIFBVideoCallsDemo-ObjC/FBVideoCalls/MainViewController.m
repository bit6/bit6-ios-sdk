//
//  MainViewController.m
//  FBVideoCalls
//
//  Created by Carlos Thurber on 12/19/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:Bit6LogoutCompletedNotification object:nil];
    }
    return self;
}

- (void) logout:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[FBSDKLoginManager alloc] init] logOut];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (Bit6.session.authenticated) {
        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
    }
}

- (IBAction)startCallingButtonTouched:(UIButton *)sender {
    [self loginToFacebook];
}

- (void) loginToFacebook
{
    __weak MainViewController *__weakSelf = self;
    
    [Bit6.session getAuthInfoCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (response[@"facebook"][@"client_id"]){
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends"] fromViewController:self.view.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error || result.isCancelled) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"An Error Ocurred" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    });
                }
                else {
                    [Bit6.session oauthForProvider:@"facebook" params:@{@"client_id":response[@"facebook"][@"client_id"], @"access_token":[FBSDKAccessToken currentAccessToken].tokenString} completion:^(NSDictionary *response, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!error) {
                                if (__weakSelf.presentingViewController==nil) {
                                    [__weakSelf performSegueWithIdentifier:@"loginCompleted" sender:nil];
                                }
                            }
                            else {
                                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            }
                        });
                    }];
                }
            }];
        }
    }];
}

@end
