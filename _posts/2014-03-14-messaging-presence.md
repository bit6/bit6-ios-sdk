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


### Detect when the Recipient is Typing

Register as an observer for changes in the conversations:

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(conversationsChangedNotification:)
                           name:Bit6ConversationsChangedNotification
                         object:nil];
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver(self,
							selector: "conversationsChangedNotification:", 
                                name: Bit6ConversationsChangedNotification, 
                              object: nil)
```

Upon receiving a notification, update the UI:

```objc
//ObjectiveC
- (void) conversationsChangedNotification:(NSNotification*)notification
{
	Bit6Conversation *conversation = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([conversation isEqual:self.conversation]) {
    	if ([change isEqualToString:Bit6UpdatedKey]) {
    		NSLog(@"%@ is typing...",conversation.typingAddress.displayName);
    	}
    }
}
```
```swift
//Swift
func conversationsChangedNotification(notification:NSNotification){
   let conversation = notification.userInfo[Bit6ObjectKey]
   let change = notification.userInfo[Bit6ChangeKey]
   
   if conversation.isEqual(self.conversation) {
   		if change == Bit6UpdatedKey {
   			NSLog("\(conversation.typingAddress.displayName) is typing...")
   		}
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
