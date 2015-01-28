//
//  AppDelegate.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    #warning Remember to set your api key
    [Bit6 startWithApiKey:@"your_api_key" pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT launchingWithOptions:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [super didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
