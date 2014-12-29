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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:Bit6LogoutStartedNotification object:nil];
    }
    return self;
}

- (void) logout:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    [[FBSession activeSession] closeAndClearTokenInformation];
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([Bit6Session isConnected]) {
        if ([[Bit6Session userIdentity].kind intValue] == Bit6AddressKind_FACEBOOK) {
            [FBSession openActiveSessionWithAllowLoginUI:YES];
        }
        [self performSegueWithIdentifier:@"loginCompleted" sender:nil];
    }
    
    [super viewWillAppear:animated];
}

- (IBAction)startCallingButtonTouched:(UIButton *)sender {
    [self loginToFacebook];
}

- (void) loginToFacebook
{
    __weak MainViewController *__weakSelf = self;
    
    [Bit6Session getAuthInfoCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (response[@"facebook"][@"client_id"]){
            [[FBSession activeSession] closeAndClearTokenInformation];
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email",@"user_friends"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                if (state==FBSessionStateOpen) {
                    [Bit6Session oauthForProvider:Bit6SessionProvider_FACEBOOK params:@{@"client_id":response[@"facebook"][@"client_id"], @"access_token":FBSession.activeSession.accessTokenData.accessToken} completion:^(NSDictionary *response, NSError *error) {
                        if (!error) {
                            if (__weakSelf.presentingViewController==nil) {
                                [__weakSelf performSegueWithIdentifier:@"loginCompleted" sender:nil];
                            }
                        }
                        else {
                            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                }
            }];
        }
    }];
}

@end
