---
category: Extra
title: 'Custom Notifications'
layout: nil
---

### Custom Notifications

__1. Listen to custom Bit6 notifications__

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(receivedRTNotification:) 
                                             name:Bit6CustomRtNotification
                                           object:nil];

- (void) receivedRTNotification:(NSNotification*)notification
{
    Bit6Address *from = notification.userInfo[@"from"];
  	Bit6Address *to = notification.userInfo[@"to"];
	NSString *type = notification.userInfo[@"type"];
}
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver(self, 
										selector: "receivedRTNotification:", 
											name: Bit6CustomRtNotification, 
										  object: nil)

func receivedRTNotification(notification:NSNotification)
{
	var from : Bit6Address = notification.userInfo["from"]
    var to : Bit6Address = notification.userInfo["to"]
    var type : String = notification.userInfo["type"]
}
```

__2. Sending custom Bit6 notifications__

```objc
//ObjectiveC
Bit6Address *address = ... ;
[Bit6 sendNotificationToAddress:address type:@"custom_type" data:nil];
```
```swift
//Swift
var address : Bit6Address = ...
Bit6.sendNotificationToAddress(address, type:"custom_type", data:nil)
```