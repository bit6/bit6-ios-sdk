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
Bit6CallController *callController = [Bit6 startCallToPhoneNumber:destination];

if (callController){
	//create an in-call UIViewController
	Bit6CallViewController *callVC = [Bit6CallViewController createDefaultCallViewController];

    [callController connectToViewController:callVC];
}
else {
    //call failed
}
```
```swift
//Swift
var destination = "+14445556666";
var callController = Bit6.startCallToPhoneNumber(destination)

if callController != nil {
	//create an in-call UIViewController
    var callVC = Bit6CallViewController.createDefaultCallViewController()

    callController.connectToViewController(callVC)
}
else {
    //call failed
}
```