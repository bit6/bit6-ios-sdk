//
//  AppDelegate.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

#warning Remember to set your api key
#warning Remember to set your Parse keys
#define BIT6_API_KEY (@"BIT6_API_KEY")
#define PARSE_APP_ID (@"kC9jO1ea3baZkPSZpoYRgFxmcIwy2exYQuxKI8jh")
#define PARSE_CLIENT_KEY (@"DzcNRkUaRCmE3IHoba5htiWxV4lcWWQnflPVvtVo")

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    NSAssert(![PARSE_APP_ID isEqualToString:@"PARSE_APP_ID"], @"[Parse SDK]: Setup your Parse application id.");
    NSAssert(![PARSE_CLIENT_KEY isEqualToString:@"PARSE_CLIENT_KEY"], @"[Parse SDK]: Setup your Parse client key.");
    
    [Bit6 startWithApiKey:BIT6_API_KEY];
    
    NSDictionary *remoteNotificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [Bit6.pushNotification didReceiveRemoteNotification:remoteNotificationPayload];
    }
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
    
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

- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [Bit6.pushNotification didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [Bit6.pushNotification didFailToRegisterForRemoteNotificationsWithError:error];
}

@end
