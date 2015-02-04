---
title: 'Getting Started'
---

### Get Bit6 API Key
Go to [Dashboard](https://dashboard.bit6.com/) and get the API Key for your app.

### Add Bit6 SDK to your iOS Xcode project

__Step 1.__ [Download](https://github.com/bit6/bit6-ios-sdk/) the Bit6 SDK.

__Step 2.__ Configure 'Linked Frameworks and Libraries' - add `Bit6SDK.framework` as well as the libraries: `libicucore.dylib`, `libz.dylib`, `libstdc++.dylib`, `libsqlite3.dylib` and `GLKit.framework`.
<img class="shot" src="images/frameworks.png"/>

__Step 3.__ Add `Bit6Resources.bundle` to "Supporting Files".
<img class="shot" src="images/resources.png"/>

__Step 4.__ Set the Architectures value to be `$(ARCHS_STANDARD_32_BIT)` for iPhone Simulators and `$(ARCHS_STANDARD)` for devices.
<img class="shot" src="images/architectures.png"/>

__Step 5.__ In your project settings add `-ObjC -stdlib=libc++` to the 'Other Linker Flags'
<img class="shot" src="images/other_linker_flags.png"/>

__Step 6.__ If you are working on a Swift project remember to set the Swift-ObjectiveC Bridge Header file
<img class="shot" src="images/swift_bridge.png"/>


### Setup Application Delegate

In your Application Delegate:

__Step 1.__ Import Bit6: `#import <Bit6_SDK/Bit6SDK.h>`

__Note.__ If you are working on a Swift project you need to add this import on the Swift-ObjectiveC Bridge Header file

__Step 2.__ Make sure your AppDelegate extends Bit6ApplicationManager

```objc
//ObjectiveC
@interface AppDelegate : Bit6ApplicationManager <UIApplicationDelegate>
...
@end
```

```swift
//Swift
class AppDelegate: UIApplicationDelegate, Bit6ApplicationManager {
    
}
```
 
__Step 3.__ Launch Bit6 with your API Key

```objc
//ObjectiveC
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6 startWithApiKey:@"your_api_key" 
              pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT 
              launchingWithOptions:launchOptions];
    
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
        
        Bit6.startWithApiKey("your_api_key", 
              pushNotificationMode: Bit6PushNotificationMode.DEVELOPMENT,
              launchingWithOptions: launchOptions);
        
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```