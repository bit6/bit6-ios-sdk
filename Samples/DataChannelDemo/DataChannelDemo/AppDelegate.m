//
//  AppDelegate.m
//  DataChannelDemo
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import <Bit6SDK/Bit6SDK.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) UISplitViewController *splitView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #warning Remember to set your api key
    [Bit6 startWithApiKey:@"your_api_key" apnsProduction:NO];
    
    self.splitView = (UISplitViewController*)self.window.rootViewController;
    self.splitView.minimumPrimaryColumnWidth = 400;
    self.splitView.maximumPrimaryColumnWidth = 400;
    self.splitView.delegate = self;
    
    [Bit6.session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (! error) {
            self.window.rootViewController.view.hidden = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter your username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", @"Anonymous", nil];
            alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [alert show];
        }
    }];
    
    return YES;
}

- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)svc
{
    return UISplitViewControllerDisplayModeAllVisible;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        if (buttonIndex==1) {
            NSString *username = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            [self loginWithUsername:username password:password];
        }
        else {
            [Bit6.session anonymousWithCompletionHandler:[self loginCompletionHandler]];
        }
    }
}

- (void) loginWithUsername:(NSString*)username password:(NSString*)password
{
    Bit6Address *userIdentity = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    [Bit6.session loginWithUserIdentity:userIdentity password:password completionHandler:[self loginCompletionHandler]];
}

- (Bit6CompletionHandler) loginCompletionHandler
{
    return ^(NSDictionary *response, NSError *error) {
        if (!error) {
            self.window.rootViewController.view.hidden = NO;
        }
        else {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
}

@end
