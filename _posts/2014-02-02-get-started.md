---
title: 'Getting Started'
---

### Get Bit6 API Key
Go to [Dashboard](https://dashboard.bit6.com/) and get the API Key for your app.

### Manual Configuration

__Step 1.__ [Download](https://github.com/bit6/bit6-ios-sdk/) the Bit6 SDK.

__Step 2.__ Configure 'Linked Frameworks and Libraries' - add `Bit6SDK.framework` as well as the libraries: `libicucore.dylib`, `libz.dylib`, `libstdc++.dylib`, `libsqlite3.dylib`, `CoreMedia`, `AudioToolbox`, `AVFoundation`, `AssetsLibrary`, `SystemConfiguration`, `MediaPlayer`, `CoreLocation` and `GLKit`.
<img class="shot" src="images/frameworks.png"/>

__Step 3.__ Add `Bit6Resources.bundle` to "Supporting Files".
<img class="shot" src="images/resources.png"/>

__Step 4.__ Set the Architectures value to be `$(ARCHS_STANDARD_32_BIT)` for iPhone Simulators and `$(ARCHS_STANDARD)` for devices.
<img class="shot" src="images/architectures.png"/>

__Step 5.__ In your project settings add `-ObjC` to the 'Other Linker Flags'
<img class="shot" src="images/other_linker_flags.png"/>

__Step 6.__ If you are working on a Swift project remember to set the Swift-ObjectiveC Bridge Header file
<img class="shot" src="images/swift_bridge.png"/>


### Configuration using Cocoapods
[![Version](https://img.shields.io/cocoapods/v/Bit6.svg?style=flat)](http://cocoadocs.org/docsets/Bit6)
[![License](https://img.shields.io/cocoapods/l/Bit6.svg?style=flat)](http://cocoadocs.org/docsets/Bit6)
[![Platform](https://img.shields.io/cocoapods/p/Bit6.svg?style=flat)](http://cocoadocs.org/docsets/Bit6)

#### Installation

Bit6 starting from version v0.8.5 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Bit6"

__Note__ If you are working on a Swift project remember to set a Swift-ObjectiveC Bridge Header file
<img class="shot" src="images/swift_bridge.png"/>

### Setup Application Delegate

__Step 1.__ Import Bit6: `#import <Bit6_SDK/Bit6SDK.h>`.

__Note.__ If you are working on a Swift project you need to add this import on the Swift-ObjectiveC Bridge Header file
 
__Step 2.__ Launch Bit6 with your API Key.

```objc
//ObjectiveC
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6 startWithApiKey:@"your_api_key" apnsProduction:NO];
    
		NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	    if (remoteNotificationPayload) {
	        [[Bit6 pushNotification] didReceiveRemoteNotification:remoteNotificationPayload];
	    }
    
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```

```swift
//Swift
func application(application: UIApplication, 
	didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        Bit6.startWithApiKey("your_api_key", apnsProduction: false);
        
        if let remoteNotificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            Bit6.pushNotification().didReceiveRemoteNotification(remoteNotificationPayload as [NSObject : AnyObject])
        }
        
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```

__Step 3.__ Support for Push Notifications

Implement the following methods in your AppDelegate

```objc
//ObjectiveC
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [[Bit6 pushNotification] handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[Bit6 pushNotification] didReceiveRemoteNotification:userInfo];
}

- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[Bit6 pushNotification] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[Bit6 pushNotification] didFailToRegisterForRemoteNotificationsWithError:error];
}
```

```swift
//Swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
   application.registerForRemoteNotifications()
}
    
func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
   Bit6.pushNotification().handleActionWithIdentifier(identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
}
    
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
   Bit6.pushNotification().didReceiveRemoteNotification(userInfo)
}
    
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
   Bit6.pushNotification().didReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
}
    
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
   Bit6.pushNotification().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
}
    
func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
   Bit6.pushNotification().didFailToRegisterForRemoteNotificationsWithError(error)
}

```