//
//  AppDelegate.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"

#warning Remember to set your api key
#define BIT6_API_KEY (@"BIT6_API_KEY")

@interface AppDelegate ()
@property (nonatomic, strong) Bit6CallController *callController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    
    //prepare to receive incoming calls
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingCallNotification:) name:Bit6IncomingCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAddedNotification:) name:Bit6CallAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPermissionsMissingNotification:) name:Bit6CallPermissionsMissingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMissedNotification:) name:Bit6CallMissedNotification object:nil];
    
    //starting Bit6 SDK
    [Bit6 startWithApiKey:BIT6_API_KEY];
    
    return YES;
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [Bit6.pushNotification didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [Bit6.pushNotification didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [Bit6.pushNotification didFailToRegisterForRemoteNotificationsWithError:error];
}

#pragma mark - Call Listener

- (void)incomingCallNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    
    //there's a call prompt showing at the time
    if (self.callController) {
        //if this is not the same call as the one being shown for the prompt then we reject it
        if ( ![self.callController isEqual:callController] ) {
            [callController decline];
        }
    }
    else {
        //the call was answered by taping the push notification
        if (callController.answered) {
            callController.localStreams = callController.remoteStreams;
            [callController start];
        }
        else {
            self.callController = callController;
            
            //show a prompt to answer the call
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:callController.incomingAlert message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            if (callController.hasRemoteAudio) {
                [alertView addAction:[UIAlertAction actionWithTitle:@"Audio" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    callController.localStreams = Bit6CallStreams_Audio;
                    [callController start];
                    self.callController = nil;
                }]];
            }
            if (callController.hasRemoteVideo) {
                [alertView addAction:[UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    callController.localStreams = Bit6CallStreams_Audio|Bit6CallStreams_Video;
                    [callController start];
                    self.callController = nil;
                }]];
            }
            [alertView addAction:[UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [callController decline];
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
    Bit6CallViewController *callViewController = [Bit6 createViewControllerForCall:callController];
    [callViewController show];
}

//there's restricted access to microphone or camera
- (void)callPermissionsMissingNotification:(NSNotification*)notification
{
    NSError *error = notification.userInfo[Bit6ErrorKey];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:error.localizedDescription message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
}

//missed call
- (void)callMissedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    if (self.callController == callController) {
        self.callController = nil;
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSString *title = [NSString stringWithFormat:@"Missed Call from %@",callController.other.value];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
}

@end
