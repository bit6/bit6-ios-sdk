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
    return true
}
```


### "Typing" Notifications

You can check who is typing for a specific conversation:

```objc
//ObjectiveC
Bit6Conversation *conv = ...
Bit6Address *whoIsTyping = conv.typingAddress;
```
```swift
//Swift
let conv = ...
let whoIsTyping = conv.typingAddress
```

To detect when someone is typing register as an observer:

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(typingBeginNotification:)
                           name:Bit6TypingDidBeginRtNotification
                         object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(typingEndNotification:)
                           name:Bit6TypingDidEndRtNotification
                         object:nil];
                         
- (void)typingBeginNotification:(NSNotification*)notification
{
    Bit6Address* fromAddress = notification.userInfo[@"from"];
    Bit6Address* convervationAddress = notification.object;
}
- (void)typingEndNotification:(NSNotification*)notification
{
    Bit6Address* fromAddress = notification.userInfo[@"from"];
    Bit6Address* convervationAddress = notification.object;
}    
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver(self,
							selector:"typingBeginNotification:", 
                                name:Bit6TypingDidBeginRtNotification, 
                              object:nil)
NSNotificationCenter.defaultCenter().addObserver(self,
							selector:"typingEndNotification:", 
                                name:Bit6TypingDidEndRtNotification, 
                              object:nil)

func typingBeginNotification(notification:NSNotification){
	let fromAddress = notification.userInfo!["from"] as! Bit6Address
	let convervationAddress = notification.object as! Bit6Address
}
func typingEndNotification(notification:NSNotification){
	let fromAddress = notification.userInfo!["from"] as! Bit6Address
	let convervationAddress = notification.object as! Bit6Address
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
  let from : Bit6Address = notification.userInfo["from"]
  let to : Bit6Address = notification.userInfo["to"]
  let type : String = notification.userInfo["type"]
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
