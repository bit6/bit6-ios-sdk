---
category: calling
title: 'PSTN Calls'
layout: nil
---

### Make a PSTN (Phone) Call

For the test purposes we allow short 1 minute calls to destinations in US and Canada (numbers starting with +1). In later releases we will also add billing, which will in turn allow to connect calls of any length to any destination number.

```objc
//ObjectiveC
NSString *destination = @"+14445556666";
if (![Bit6 startCallToPhoneNumber:destination]){
	//call failed
}
```
```swift
//Swift
var destination = "+14445556666";
if (!Bit6.startCallToPhoneNumber(destination)) {
	//call failed
}
```
In the current beta version we show very basic in-call UI. The future versions will allow UI customization.