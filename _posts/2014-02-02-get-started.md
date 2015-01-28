---
title: 'Getting Started'
---

### Get Bit6 API Key
You will need an API key to use the SDK. Get it [here](http://bit6.com/contact/).

### Add Bit6 SDK to your iOS Xcode project

1. [Download](https://github.com/bit6/bit6-ios-sdk/) the Bit6 SDK.

2. Add <b>`Bit6SDK.framework`</b> to "Linked Frameworks and Libraries". Also add the following libraries to your project: <b>`libicucore.dylib`</b>, <b>`libz.dylib`</b>, <b>`libstdc++.dylib`</b>, <b>`libsqlite3.dylib`</b> and <b>`GLKit.framework`</b>.
<img style="max-width:100%" src="images/frameworks.png"/>

3. Add <b>`Bit6Resources.bundle`</b> to "Supporting Files".
<img style="max-width:100%" src="images/resources.png"/>

4. Set the Architectures value to be <b>`$(ARCHS_STANDARD_32_BIT)`</b> for iPhone Simulators and <b>`$(ARCHS_STANDARD)`</b> for devices.
<img style="max-width:100%" src="images/architectures.png"/>

5. In your project settings add <b>`-ObjC -stdlib=libc++`</b> to the “Other Linker Flags”
<img style="max-width:100%" src="images/other_linker_flags.png"/>

6. If you are working on a Swift project remember to set the Swift-ObjectiveC Bridge Header file
<img style="max-width:100%" src="images/swift_bridge.png"/>

### Setup Application Delegate
In your Application Delegate:

__Step 1.__ Import Bit6: <b>`#import <Bit6_SDK/Bit6SDK.h>`</b>

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