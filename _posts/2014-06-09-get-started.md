---
title: 'Getting Started'

layout: nil
---

###Add Bit6 SDK to your iOS Xcode project

1. [Download](https://github.com/bit6/bit6-ios-sdk/) the SDK and install the package. By default the SDK and the sample apps are installed in `~/Documents/Bit6SDK`

2. Add the files Bit6_SDK.framework and Bit6Resources.bundle to your project.

3. In your project settings add -ObjC to the “Other Linker Flags”
<img style="width:100%" src="images/other_linker_flags.png"/>

###Get a Bit6 API Key
You will need an API key in order to initialize and use Bit6 SDK. Send an email to dev@bit6.com to receive an application key.

###Setup Application Delegate
In your Application Delegate:

__Step 1.__ Import Bit6: <b>`#import <Bit6_SDK/Bit6SDK.h>`</b>

__Step 2.__ Launch Bit6 with your API Key

```objc
- (BOOL)application:(UIApplication *)application 
                  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        [Bit6 init:@"your_api_key"];
    
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```

__Step 3.__ Register for Remote Notifications  

```objc
- (BOOL)application:(UIApplication *)application 
                  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        NSDictionary *remoteNotificationPayload = 
            [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotificationPayload) {
            [[NSNotificationCenter defaultCenter] 
              postNotificationName:Bit6RemoteNotificationReceived object:nil 
                          userInfo:remoteNotificationPayload];
        }

        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }

    - (void)application:(UIApplication *)application 
                         didReceiveRemoteNotification:(NSDictionary *)userInfo 
    {
        [[NSNotificationCenter defaultCenter] 
                               postNotificationName:Bit6RemoteNotificationReceived 
                                             object:nil userInfo:userInfo];
    }

    - (void) application:(UIApplication*)application 
                didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
    {
        [[NSNotificationCenter defaultCenter] 
                               postNotificationName:Bit6DidRegisterForRemoteNotifications 
                                             object:nil 
                                           userInfo:@{@"deviceToken":deviceToken}];
    }

    - (void) application:(UIApplication*)application 
                          didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
    {
        [[NSNotificationCenter defaultCenter] 
             postNotificationName:Bit6DidFailToRegisterForRemoteNotifications 
                           object:nil userInfo:@{@"error":error}];
    }
```
