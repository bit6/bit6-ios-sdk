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

In your Application Delegate:

__Step 1.__ Import Bit6: `#import <Bit6_SDK/Bit6SDK.h>` in you `AppDelegate.h` file.

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
              pushNotificationMode: .DEVELOPMENT,
              launchingWithOptions: launchOptions);
        
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```