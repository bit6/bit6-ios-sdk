---
category: calling
title: 'Phone/PSTN Calls'
---

### Start a Phone Call

Bit6 interconnects with the phone networks (PSTN) and allows making outgoing phone calls.

Phone numbers must be in [E164](http://en.wikipedia.org/wiki/E.164) format, prefixed with `+`. So a US (country code `1`) number `(555) 123-1234` must be presented as `+15551231234`.

For the test purposes we allow short 1 minute calls to destinations in US and Canada. In later releases we will also add billing, which will in turn allow to connect calls of any length to any destination number.

```objc
//ObjectiveC
NSString *destination = @"+14445556666";
Bit6CallController *callController = [Bit6 createCallToPhoneNumber:destination];

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
let destination = "+14445556666";
let callController = Bit6.createCallToPhoneNumber(destination)

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
    //call failed
}
```