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
UIViewController *vc = //create custom viewcontroller or nil to use the default one

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
var vc : UIViewController! = //create custom viewcontroller or nil to use the default one

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
In the current version we show very basic in-call UI. You can create your own UIViewController to handle the calls and use it in the `[callController connectToViewController:completion]` api call.

### Listen to changes in Call status

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
    
    //decline the call
    //[callController declineCall];
    
    //answer the call
	//call [callController connectToViewController:... completion:...]
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
	//call callController.connectToViewController(..., completion:...)
}
```

To get caller name call `callController.other`

To check if it is video or voice call then call `callController.hasVideo`