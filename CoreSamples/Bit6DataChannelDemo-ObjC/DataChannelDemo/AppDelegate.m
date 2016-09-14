//
//  AppDelegate.m
//  DataChannelDemo
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@import Bit6;

#warning Remember to set your api key
#define BIT6_API_KEY (@"BIT6_API_KEY")

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) Bit6CallController *callController;
@property (nonatomic, strong) UISplitViewController *splitView;
@property (nonatomic, strong) MasterViewController *masterVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:Bit6LogoutCompletedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if ([note.userInfo[Bit6ErrorKey] intValue] == NSURLErrorUserCancelledAuthentication) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Bit6AlertView showAlertControllerWithTitle:@"Invalid Session" message:@"Please login again" cancelButtonTitle:@"OK"];
            });
        }
    }];
    
    //prepare to receive incoming calls
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingCallNotification:) name:Bit6IncomingCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAddedNotification:) name:Bit6CallAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPermissionsMissingNotification:) name:Bit6CallPermissionsMissingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMissedNotification:) name:Bit6CallMissedNotification object:nil];
    
    //starting Bit6 SDK
    [Bit6 startWithApiKey:BIT6_API_KEY];
    
    self.splitView = (UISplitViewController*)self.window.rootViewController;
    self.splitView.minimumPrimaryColumnWidth = 400;
    self.splitView.maximumPrimaryColumnWidth = 400;
    self.splitView.delegate = self;
    
    UINavigationController *navController = self.splitView.viewControllers[0];
    self.masterVC = (MasterViewController*) navController.topViewController;
    
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

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [Bit6.pushNotification didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [Bit6.pushNotification didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [Bit6.pushNotification didReceiveNotificationUserInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [Bit6.pushNotification didReceiveNotificationUserInfo:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forNotificationUserInfo:userInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forNotificationUserInfo:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [Bit6.pushNotification didReceiveNotificationUserInfo:notification.userInfo];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forNotificationUserInfo:notification.userInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forNotificationUserInfo:notification.userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
}

#pragma mark - Call Listener

- (void)incomingCallNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    
    //there's a call prompt showing at the time
    if (self.callController) {
        //if this is not the same call as the one being shown for the prompt then we reject it
        if ( ![self.callController isEqual:callController] ) {
            [callController hangup];
        }
    }
    else {
        callController.remoteStreams = callController.availableStreamsForIncomingCall;
        
        //the call was answered by taping the push notification
        if (callController.answered) {
            callController.localStreams = callController.remoteStreams;
            [callController start];
        }
        else {
            self.callController = callController;
            
            //show a prompt to answer the call
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:callController.incomingAlert message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertView addAction:[UIAlertAction actionWithTitle:@"Answer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                callController.localStreams = callController.remoteStreams;
                [callController start];
                self.callController = nil;
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [callController hangup];
                self.callController = nil;
            }]];
            
            [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
            
            //play the ringtone
            [callController playRingtone];
        }
    }
}

//ready to start the call, lets show the UI
- (void)callAddedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    self.masterVC.callController = callController;
}

//there's restricted access to microphone or camera
- (void)callPermissionsMissingNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    NSError *error = callController.error;
    [Bit6AlertView showAlertControllerWithTitle:error.localizedDescription message:nil cancelButtonTitle:@"OK"];
}

//missed call
- (void)callMissedNotification:(NSNotification*)notification
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    if (appState == UIApplicationStateActive) {
        Bit6CallController *callController = notification.object;
        if (self.callController == callController) {
            self.callController = nil;
            [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        NSString *title = [NSString stringWithFormat:@"Missed Call from %@",callController.otherDisplayName];
        [Bit6AlertView showAlertControllerWithTitle:title message:nil cancelButtonTitle:@"OK"];
    }
}

@end
