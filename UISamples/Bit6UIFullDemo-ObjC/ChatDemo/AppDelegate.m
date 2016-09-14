//
//  AppDelegate.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomCallViewController.h"

#warning Remember to set your api key
#define BIT6_API_KEY (@"BIT6_API_KEY")

@interface AppDelegate ()
@property (nonatomic, strong) Bit6CallController *callController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:Bit6LogoutCompletedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if ([note.userInfo[Bit6ErrorKey] intValue] == NSURLErrorUserCancelledAuthentication) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Bit6AlertView showAlertControllerWithTitle:@"Invalid Session" message:@"Please login again" cancelButtonTitle:@"OK"];
            });
        }
    }];
    
    #warning change to Bit6CallMediaModeMix to enable recording during a call
    [BXU setCallMediaMode:Bit6CallMediaModeP2P];

    #warning change to CustomCallViewController and play with source files to change the UI
    [Bit6 setInCallClass:[BXUCallViewController class]];
    
    //prepare for incoming messages
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessageNotification:) name:Bit6IncomingMessageNotification object:nil];
    
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
    if ([BXUIncomingCallPrompt callController]) {
        
        //if this is not the same call as the one being shown for Bit6IncomingCallPrompt then we reject it
        if ( ![[BXUIncomingCallPrompt callController] isEqual:callController] ) {
            [callController hangup];
        }
    }
    else {
        //the call was answered by taping the push notification
        if (callController.answered) {
            callController.remoteStreams = [BXU availableStreamsIn:callController.availableStreamsForIncomingCall];
            callController.localStreams = [BXU availableStreamsIn:callController.availableStreamsForIncomingCall];
            callController.mediaMode = [BXU callMediaMode];
            [callController start];
        }
        else {
            [BXUIncomingCallPrompt showForCallController:callController];
        }
    }
}

- (void)callAddedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    Bit6CallViewController *vc = [Bit6 createViewControllerForCall:callController];
    [vc show];
}

- (void)callPermissionsMissingNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    NSError *error = callController.error;
    [Bit6AlertView showAlertControllerWithTitle:error.localizedDescription message:nil cancelButtonTitle:@"OK"];
}

- (void)callMissedNotification:(NSNotification*)notification
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    if (appState == UIApplicationStateActive) {
        Bit6CallController *callController = notification.object;
        NSString *title = [NSString stringWithFormat:@"Missed Call from %@",[BXU displayNameForAddress:callController.other]];
        [Bit6AlertView showAlertControllerWithTitle:title message:nil cancelButtonTitle:@"OK"];
    }
}

#pragma mark - Message Listener

- (void)incomingMessageNotification:(NSNotification*)notification
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    Bit6Address *address = notification.userInfo[Bit6AddressKey];
    BOOL tapped = [notification.userInfo[Bit6TappedKey] boolValue];
    NSString *message = notification.userInfo[Bit6MessageKey];
    
    //the user is not inside the conversation
    if (![[Bit6 currentConversation].address isEqual:address]) {
        //the user tapped the notification
        if (tapped) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BXUConversationSelectedNotification object:address];
        }
        //we were inside the app when the notification arrived, we show the banner
        else {
            if (appState != UIApplicationStateBackground) {
                [BXU showNotificationFrom:address message:message tappedHandler:nil];
            }
        }
    }
}

@end
