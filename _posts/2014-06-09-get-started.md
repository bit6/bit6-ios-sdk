---
title: 'Getting Started'

layout: nil
---
###Add Bit6 SDK to your iOS Xcode project

1. [Download](https://github.com/bit6/bit6-ios-sdk/) the Bit6 SDK.

2. Add <b>`libicucore.dylib`</b> and <b>`libz.dylib`</b> to your project.

3. Add <b>`Bit6SDK.framework`</b> to "Linked Frameworks and Libraries".
<img style="max-width:100%" src="images/frameworks.png"/>

4. Add <b>`Bit6Resources.bundle`</b> to "Supporting Files".
<img style="max-width:100%" src="images/resources.png"/>

5. In your project settings set the Architectures value to <b>`$(ARCHS_STANDARD_32_BIT)`</b>
<img style="max-width:100%" src="images/architectures.png"/>

6. In your project settings add <b>`-ObjC`</b> to the “Other Linker Flags”
<img style="max-width:100%" src="images/other_linker_flags.png"/>

###Get a Bit6 API Key
You will need an API key in order to initialize and use Bit6 SDK. Send an email to dev@bit6.com to receive an application key.

###Setup Application Delegate
In your Application Delegate:

__Step 1.__ Import Bit6: <b>`#import <Bit6_SDK/Bit6SDK.h>`</b>


__Step 2.__ Make sure your AppDelegate extends Bit6ApplicationManager

```objc
@interface AppDelegate : Bit6ApplicationManager <UIApplicationDelegate>
...
@end
```

__Step 3.__ Launch Bit6 with your API Key

```objc
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6 init:@"your_api_key" 
              pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT 
              launchingWithOptions:launchOptions];
    
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```