---
category: calling
title: 'Voice & Video Calls'
---

### Make a Call

See the Bit6CallDemo and Bit6CallDemo-Swift sample projects included with the sdk.

__Step1.__ Start the call

```objc
//ObjectiveC
Bit6Address * address = ...
Bit6CallController *callController = [Bit6 startCallToAddress:address hasAudio:YES hasVideo:NO hasData:NO];

if (callController){
	//we listen to call state changes
	[callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
	
	//create the default in-call UIViewController
	Bit6CallViewController *callVC = [Bit6CallViewController createDefaultCallViewController];
	
	//start the call
    [callController connectToViewController:callVC];
}
else {
    //cannot make call to specified address
}
```
```swift
//Swift
var address : Bit6Address = ...
var callController = Bit6.startCallToAddress(address, hasAudio:true, hasVideo:false, hasData:false)

if callController != nil {
	//we listen to call state changes
	callController.addObserver(self, forKeyPath:"callState", options: .Old, context:nil)
	
	//create the default in-call UIViewController
	var callVC = Bit6CallViewController.createDefaultCallViewController()
	
	//start the call
    callController.connectToViewController(callVC)
}
else {
    //cannot make call to specified address
}
```

__Step2__ Listen to call state changes

```objc
//ObjectiveC
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[Bit6CallController class]]) {
        if ([keyPath isEqualToString:@"callState"]) {
            [self callStateChangedNotification:object];
        }
    }
}

- (void) callStateChangedNotification:(Bit6CallController*)callController
{
    dispatch_async(dispatch_get_main_queue(), ^{
    	//the call is starting: show the viewController
        if (callController.callState == Bit6CallState_PROGRESS) {
            [Bit6 presentCallViewController];
        }
        //the call ended: remove the observer and dismiss the viewController
        else if (callController.callState == Bit6CallState_END) {
            [callController removeObserver:self forKeyPath:@"callState"];
        }
        //the call ended with an error: remove the observer and dismiss the viewController
        else if (callController.callState == Bit6CallState_ERROR) {
            [callController removeObserver:self forKeyPath:@"callState"];
            [[[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:callController.error.localizedDescription?:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
}
```
```swift
//Swift
override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
   dispatch_async(dispatch_get_main_queue()) {
       if object.isKindOfClass(Bit6CallController) {
           if keyPath == "callState" {
               self.callStateChangedNotification(object as Bit6CallController)
           }
       }
   }
}

func callStateChangedNotification(callController:Bit6CallController) {
   dispatch_async(dispatch_get_main_queue()) {
       //the call is starting: show the viewController
       if callController.callState == .PROGRESS {
           Bit6.presentCallViewController()
       }
       //the call ended: remove the observer and dismiss the viewController
       else if callController.callState == .END {
           callController.removeObserver(self, forKeyPath:"callState")
       }
       //the call ended with an error: remove the observer and dismiss the viewController
       else if callController.callState == .ERROR {
           callController.removeObserver(self, forKeyPath:"callState")
           
           var alert = UIAlertController(title:"An Error Occurred", message: callController.error.localizedDescription, preferredStyle: .Alert)
           alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
           self.view.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
       }
   }
}
```

### Receive Calls

See the Bit6CallDemo and Bit6CallDemo-Swift sample projects included with the sdk.

By default the incoming calls are handled by a singleton instance of `Bit6IncomingCallHandler`. 

You can customize the incoming in-call screen, the incoming call window prompt or even handle the entire flow by implementing the `Bit6IncomingCallHandlerDelegate` protocol:

```objc
//ObjectiveC
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   [Bit6 incomingCallHandler].delegate = self;
}

- (Bit6CallViewController*) inCallViewController
{
	//return your custom view controller
}

- (UIView*) incomingCallNotificationBannerContentView
{
	/*
	Use the following tag values for your controls:
	15: title UILabel to show the app name
 	16: message label
 	17: decline button
 	18: answer button
	*/
	//return your custom in-call prompt view
}

//implement this method if you want to override the default incoming call flow.
- (void) receivedIncomingCallNotification:(NSNotification*)notification
{
	Bit6CallController *callController = [Bit6 callControllerFromIncomingCallNotification:notification];
	//the rest of your code
}
```
```swift
//Swift
func application(application: UIApplication, 
	didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
		Bit6.incomingCallHandler().delegate = self
    }

func inCallViewController() -> Bit6CallViewController
{
	//return your custom view controller
}

func incomingCallNotificationBannerContentView() -> UIView
{
	/*
	Use the following tag values for your controls:
	15: title UILabel to show the app name
 	16: message label
 	17: decline button
 	18: answer button
	*/
	//return your custom in-call prompt view
}

//implement this method if you want to override the default incoming call flow.
func receivedIncomingCallNotification(notification:NSNotification) {
   var callController = Bit6.callControllerFromIncomingCallNotification(notification)
   //the rest of your code
}
```

Or you can you can customize the entire incoming call flow (See the code included in the sample projects AppDelegate class).

To get caller name: `callController.otherDisplayName`

To get incoming alert message: `callController.incomingCallAlert`

To check if it is video or voice call: `callController.hasVideo`

To play the defined ringtone: `[callController startRingtone]`

###Setting the Ringtone

1. Add the ringtone file to your Xcode project. [Apple Docs](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW6)

2. Open the [Bit6 Dashboard](https://dashboard.bit6.com) and sign in. Then select your app and open the Settings tab. Here you need to set the ringtone file name for both the APNS development and the APNS production configurations.

<img class="shot" src="images/ringtone.png"/>

###Continue Calls in the Background

You can continue the calls in the background by enable "Audio and Airplay" and "Voice over IP" Background Modes in your target configuration.

<img class="shot" src="images/background_calls.png"/>
