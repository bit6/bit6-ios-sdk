---
category: calling
title: 'Video Calls'
layout: nil
---

### Make a Video Call

```objc
//ObjectiveC
Bit6Address *otherUserAddress = ...
if (![Bit6 startCallToAddress:otherUserAddress hasVideo:YES]){
	//call failed
}
```
```swift
//Swift
var address : Bit6Address = ...
if (!Bit6.startCallToAddress(address, hasVideo: true){
	//call failed
}
```
In the current beta version we show very basic in-call UI. The future versions will allow UI customization.