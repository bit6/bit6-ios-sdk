---
title: 'Getting Started'
---

### Get Bit6 API Key
Go to [Dashboard](https://dashboard.bit6.com/) and get the API Key for your app.

### Manual Configuration

__Step 1.__ [Download](https://github.com/bit6/bit6-ios-sdk/) the Bit6 SDK.

__Step 2.__ Add `Bit6.framework` and `Bit6Resources.bundle` to your project.

__Step 3.__ Link the following frameworks and libraries: `libicucore.tdb`, `libstdc++.tdb`, `GLKit` and `VideoToolbox`.

__Step 4.__ Set the Architectures value to be `$(ARCHS_STANDARD_32_BIT)` for iPhone Simulators and `$(ARCHS_STANDARD)` for devices.
<img class="shot" src="images/architectures.png"/>

__Step 5.__ Set your Deployment Target to be iOS 7.0 or later.

__Step 6.__ In your Build Settings add `-ObjC` to the 'Other Linker Flags'


### Configuration using Cocoapods
[![Version](https://img.shields.io/cocoapods/v/Bit6.svg?style=flat)](http://cocoadocs.org/docsets/Bit6)
[![License](https://img.shields.io/cocoapods/l/Bit6.svg?style=flat)](http://cocoadocs.org/docsets/Bit6)
[![Platform](https://img.shields.io/cocoapods/p/Bit6.svg?style=flat)](http://cocoadocs.org/docsets/Bit6)

#### Installation

Bit6 starting from version v0.8.5 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

	# Uncomment this line if you're using Swift
	# use_frameworks!
    pod "Bit6"

### Building for iOS9

__Whitelist Bit6 for Network Requests__

If you compile your app with iOS SDK 9.0, you will be affected by [App Transport Security](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/). You will need to add the following to your info.plist file:

```
<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>amazonaws.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.1</string>
			</dict>
		</dict>
	</dict>
```

__Bitcode__  Bit6 SDK doesn't include support for [bitcode](https://developer.apple.com/library/prerelease/watchos/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html#//apple_ref/doc/uid/TP40012582-CH35-SW2) yet. You can disable bitcode in your target configuration:

<img class="shot" src="images/bitcode.png"/>

### Setup Application Delegate

__Step 1.__ Import Bit6: `@import Bit6;` for ObjectiveC and `import Bit6` for Swift.
 
__Step 2.__ Launch Bit6 with your API Key.

```objc
//ObjectiveC
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6 startWithApiKey:@"your_api_key"];
        
		NSDictionary *remoteNotificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
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
        
        Bit6.startWithApiKey("your_api_key")
        
        if let remoteNotificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            Bit6.pushNotification().didReceiveRemoteNotification(remoteNotificationPayload as [NSObject : AnyObject])
        }
        
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```

__Step 3.__ Support for Push Notifications

__NOTE.__ Remember to upload your development and production APNS Certificates to [Dashboard](https://dashboard.bit6.com/).

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