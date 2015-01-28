---
category: calling
title: 'Voice & Video Calls'
layout: nil
---

### Make a Call

```objc
//ObjectiveC
Bit6Address *otherUserAddress = ...
Bit6CallController *callController = [Bit6 startCallToAddress:address hasVideo:NO];
UIViewController *vc = //create a custom viewcontroller or nil to use the default one

if (callController){                           
    [callController connectToViewController:vc completion:^(UIViewController *vc, 
    														 NSError *error) 
	{
        if (error) {
            //call failed
        }
        else {
        	//register to listen changes in call status
            //add vc to the UIViewController hierarchy
        }
    }];
}
else {
    //call failed
}
```
```swift
//Swift
var address : Bit6Address = ...
var callController = Bit6.startCallToAddress(address, hasVideo:false)
var vc : UIViewController! = //create a custom viewcontroller or nil to use the default one

if (callController != nil){
    callController.connectToViewController(vc, completion:{(vc: UIViewController!, 
                                                          error: NSError!) 
	in
        if (error != nil){
            //call failed
        }
        else {
	       //register to listen changes in call status
           //add vc to the UIViewController hierarchy
        }
    })
}
else {
    //call failed
}
```

### Receive Calls

You need to register to receive incoming calls.

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver: self
                                         selector: @selector(receivedIncomingCallNotification:) 
                                             name: Bit6IncomingCallNotification 
                                           object: nil];
                                           
- (void) receivedIncomingCallNotification:(NSNotification*)notification
{
    Bit6CallController *callController = [Bit6 callControllerFromIncomingCallNotification:notification];
    
    //answer the call
    UIViewController *vc = //create a custom viewcontroller or nil to use the default one
	[callController connectToViewController:vc completion:^(UIViewController *vc, 
    														 NSError *error) 
	{
        if (error) {
            //call failed
        }
        else {
        	//register to listen changes in call status
            //add vc to the UIViewController hierarchy
        }
    }];
}
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver( self, 
                                        selector: "receivedIncomingCallNotification:", 
                                        	name: Bit6IncomingCallNotification, 
                                          object: nil)
                                          
func receivedIncomingCallNotification(notification:NSNotification) -> Void {
        
    var callController = Bit6.callControllerFromIncomingCallNotification(notification)
    
    //decline the call
    //callController.declineCall();
    
    //answer the call
    var vc : UIViewController! = //create a custom viewcontroller or nil to use the default one
    callController.connectToViewController(vc, completion:{(vc: UIViewController!, 
                                                         error: NSError!) 
	in
        if (error != nil){
            //call failed
        }
        else {
	       //register to listen changes in call status
           //add vc to the UIViewController hierarchy
        }
    })
}
```

To decline the call: `[callController declineCall]`

To get caller name: `callController.other`

To check if it is video or voice call: `callController.hasVideo`

To play the defined ringtone: `[callController startRingtone]`

###Continue Calls in the Background

You can continue the calls in the background by enable "Audio and Airplay" and "Voice over IP" Background Modes in your target configuration.

<img style="max-width:100%" src="images/background_calls.png"/>

### Listen to Status Changes During the Call

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver: self
									     selector: @selector(callStateChangedNotification:)
                                             name: Bit6CallStateChangedNotification
                                    	   object: callController];
                                           
- (void) callStateChangedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    
    if (callController.callState == Bit6CallState_END || 
        callController.callState == Bit6CallState_ERROR) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
        												name:Bit6CallStateChangedNotification
                            						  object:callController];
        
        //remove the vc from the UIViewController hierarchy
    }
}
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver( self, 
                                        selector: "callStateChangedNotification:", 
                                        	name: Bit6CallStateChangedNotification, 
                                          object: callController)

func callStateChangedNotification(notification:NSNotification) -> Void {
        var callController = notification.object as Bit6CallController
        
        if (callController.callState == Bit6CallState.END || 
            callController.callState == Bit6CallState.ERROR) {
            NSNotificationCenter.defaultCenter().removeObserver(self, 
            									name: Bit6CallStateChangedNotification, 
                        					  object: callController)
            
        //remove the vc from the UIViewController hierarchy
        }
    }
```

### Customize the In-Call Screen

You can create your own UIViewController that extends from Bit6CallViewController to customize the user experience and use it in the `[callController connectToViewController:completion]` api call.

See the Bit6CallDemo and Bit6CallDemo-Swift sample projects included with the sdk.
