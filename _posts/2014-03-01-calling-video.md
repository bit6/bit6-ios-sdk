---
category: calling
title: 'Voice & Video Calls'
---

See the Bit6CallDemo and Bit6CallDemo-Swift sample projects included with the sdk.

### Make a Call

```objc
//ObjectiveC
Bit6Address *address = ...
Bit6CallController *callController = [Bit6 createCallTo:address streams:Bit6CallStreams_Audio];

if (callController){
	//trying to reuse the previous viewController, or create a default one
	Bit6CallViewController *callViewController = [Bit6 callViewController] ?: [Bit6CallViewController createDefaultCallViewController];
	
	//set the call to the viewController
    [callViewController addCallController:callController];
    
    //start the call
    [callController start];
    
    //present the viewController
    [Bit6 presentCallViewController:callViewController];
}
else {
    //cannot make call to specified address
}
```
```swift
//Swift
let address : Bit6Address = ...
let callController = Bit6.createCallTo(address, streams:.Audio)

if callController != nil {
    //trying to reuse the previous viewController, or create a default one
    let callViewController = Bit6.callViewController() ?? Bit6CallViewController.createDefaultCallViewController()
    
    //set the call to the viewController
    callViewController.addCallController(callController)
    
    //start the call
    callController.start()
    
    //present the viewController
    Bit6.presentCallViewController(callViewController)
}
else {
    NSLog("Call Failed")
}
```

__Listen to call state changes__

```objc
//ObjectiveC

//register the observer
[callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];

//deregister observer
//[callController removeObserver:self forKeyPath:@"callState"];

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
	switch (callController.callState) {
	        
	}
}
```
```swift
//Swift

//register the observer
callController.addObserver(self, forKeyPath:"callState", options: .Old, context:nil)

//deregister observer
//callController.removeObserver(self, forKeyPath:"callState")

override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
	guard let object = object,
          let callController = object as? Bit6CallController else { return }

   if keyPath == "callState" {
       self.callStateChangedNotification(callController)
   }
}

func callStateChangedNotification(callController:Bit6CallController) {
	switch (callController.callState) {
	        
	}
}
```

### Receive Calls

By default the incoming calls are handled by a singleton instance of `Bit6IncomingCallHandler`. 

You can customize the incoming in-call screen, the incoming call window prompt or even handle the entire flow by implementing the `Bit6IncomingCallHandlerDelegate` protocol:

```objc
//ObjectiveC
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   [Bit6 incomingCallHandler].delegate = self;
   //the rest of your code
}

- (Bit6CallViewController*)inCallViewController
{
	//return your custom view controller
}

- (UIView*)incomingCallPromptContentViewForCallController:(Bit6CallController*)callController
{
	//return your custom in-call prompt view
}

//implement this method if you want to override the default incoming call flow.
- (void)receivedIncomingCall:(Bit6CallController*)callController
{
	
}
```
```swift
//Swift
func application(application: UIApplication, 
	didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
		Bit6.incomingCallHandler().delegate = self
		//the rest of your code
    }

func inCallViewController() -> Bit6CallViewController
{
	//return your custom view controller
}

func incomingCallPromptContentViewForCallController(callController: Bit6CallController) -> UIView? {
{
	//return your custom in-call prompt view
}

//implement this method if you want to override the default incoming call flow.
func receivedIncomingCall(callController: Bit6CallController) {
   
}
```

###Setting the Ringtone

1. Add the ringtone file to your Xcode project. [Apple Docs](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW6)

2. Open the [Bit6 Dashboard](https://dashboard.bit6.com) and sign in. Then select your app and open the Settings tab. Here you need to set the ringtone file name for both the APNS development and the APNS production configurations.

<img class="shot" src="images/ringtone.png"/>

###Continue Calls in the Background

You can continue the calls in the background by enable "Audio and Airplay" and "Voice over IP" Background Modes in your target configuration.

<img class="shot" src="images/background_calls.png"/>
