//
//  AppDelegate.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoContactSource.h"

#warning Remember to set your api key
#define BIT6_API_KEY (@"BIT6_API_KEY")

@interface AppDelegate ()
@property (nonatomic, strong) Bit6CallController *callController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    
    //prepare for incoming messages
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessageNotification:) name:Bit6IncomingMessageNotification object:nil];
    
    //prepare to receive incoming calls
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingCallNotification:) name:Bit6IncomingCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAddedNotification:) name:Bit6CallAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPermissionsMissingNotification:) name:Bit6CallPermissionsMissingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMissedNotification:) name:Bit6CallMissedNotification object:nil];
    
    //setting the contact source for Bit6UI
    [BXU setContactSource:[DemoContactSource new]];
    
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
    if ([BXUIncomingCallPrompt callController]) {
        
        //if this is not the same call as the one being shown for Bit6IncomingCallPrompt then we reject it
        if ( ![[BXUIncomingCallPrompt callController] isEqual:callController] ) {
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
            [BXUIncomingCallPrompt showForCallController:callController];
        }
    }
}

- (void)callAddedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    
    id<BXUContact> contact = [BXU.contactSource contactForURI:callController.other.uri];
    callController.otherDisplayName = contact.name;
    
    Bit6CallViewController *vc = [Bit6 createViewControllerForCall:callController];
    [vc show];
}

- (void)callPermissionsMissingNotification:(NSNotification*)notification
{
    NSError *error = notification.userInfo[Bit6ErrorKey];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:error.localizedDescription message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)callMissedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    NSString *title = [NSString stringWithFormat:@"Missed Call from %@",callController.otherDisplayName];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - Message Listener

- (void)incomingMessageNotification:(NSNotification*)notification
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    
    Bit6Address *address = notification.userInfo[Bit6AddressKey];
    NSString *message = notification.userInfo[Bit6MessageKey];
    
    //notification not tapped
    if (appState == UIApplicationStateActive) {
        //the user is not inside the conversation
        if (![[Bit6 currentConversation].address isEqual:address]) {
            [BXU showNotificationFrom:address message:message tappedHandler:nil];
        }
    }
    
    //notification tapped
    else if (appState == UIApplicationStateInactive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BXUConversationSelectedNotification object:address];
    }
}

@end
