---
category: messaging
title: 'Notifications'
---

### Notify the Recipient that the Sender is Typing

Call `+[Bit6 typingBeginToAddress:]`. 

If using UITextField to type, utilize its UITextFieldDelegate to send the notification:

```objc
//ObjectiveC
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
                                                       replacementString:(NSString *)string
{
	Bit6Address *otherUserAddress = ...
    [Bit6 typingBeginToAddress:otherUserAddress];
    return YES;
}
```
```swift
//Swift
func textField(textField: UITextField, 
shouldChangeCharactersInRange range: NSRange, 
           replacementString string: String) -> Bool
{
	var otherUserAddress : Bit6Address = ...
    Bit6.typingBeginToAddress(otherUserAddress)
    return true;
}
```


### Detect when the Recipient is Typing

Register as an observer for typing status:

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self 
                    selector:@selector(typingDidBeginRtNotification:) 
                       name:Bit6TypingDidBeginRtNotification 
                     object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self 
                    selector:@selector(typingDidEndRtNotification:) 
                        name:Bit6TypingDidEndRtNotification 
                      object:nil];
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver(self, 
                    selector:"typingDidBeginRtNotification:", 
                        name: Bit6TypingDidBeginRtNotification, 
                      object: nil)
NSNotificationCenter.defaultCenter().addObserver(self, 
                    selector:"typingDidEndRtNotification:", 
                        name: Bit6TypingDidEndRtNotification, 
                      object: nil)
```

Upon receiving a typing notification, update the UI:

```objc
//ObjectiveC
- (void) typingDidBeginRtNotification:(NSNotification*)notification
{
	Bit6Address *otherUserAddress = ...
    Bit6Address *address = notification.object;
    if ([address isEqual:otherUserAddress]) {
        //user is typing
    }
}

- (void) typingDidEndRtNotification:(NSNotification*)notification
{
	Bit6Address *otherUserAddress = ...
    Bit6Address *address = notification.object;
    if ([address isEqual:otherUserAddress]) {
        //user stopped typing
    }
}
```
```swift
//Swift
func typingDidBeginRtNotification(notification:NSNotification) {
	var otherUserAddress : Bit6Address = ...
    var address = notification.object as Bit6Address
    if (address.isEqual(otherUserAddress)){
        //user is typing
    }
}

func typingDidBeginRtNotification(notification:NSNotification) {
	var otherUserAddress : Bit6Address = ...
    var address = notification.object as Bit6Address
    if (address.isEqual(otherUserAddress)){
        //user stopped typing
    }
}
```


### Receiving custom notifications

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

### Sending custom notifications

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
