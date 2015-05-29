//
//  AppDelegate.m
//  FBVideoCalls
//
//  Created by Carlos Thurber on 12/19/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #warning Remember to set your api key
    [Bit6 startWithApiKey:@"your_api_key" apnsProduction:NO];
    
    NSDictionary *remoteNotificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [Bit6.pushNotification didReceiveRemoteNotification:remoteNotificationPayload];
    }
    
    #warning You need to set the FacebookAppID string on the info.plist file and add a URL Type as this fb[yourFacebookAppId] as explained in https://developers.facebook.com/docs/ios/getting-started/?locale=es_LA#configure

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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [Bit6.pushNotification didReceiveRemoteNotification:userInfo];
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

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

@end
