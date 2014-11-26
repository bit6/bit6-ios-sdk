---
category: calling
title: 'Voice Calls'
layout: nil
---

### Make an Audio Call

```objc
//ObjectiveC
Bit6Address *otherUserAddress = ...
if (![Bit6 startCallToAddress:otherUserAddress hasVideo:NO]){
	//call failed
}
```
```swift
//Swift
var address : Bit6Address = ...
if (!Bit6.startCallToAddress(address, hasVideo: false)){
	//call failed
}
```
In the current beta version we show very basic in-call UI. The future versions will allow UI customization.