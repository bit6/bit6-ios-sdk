---
category: basic messaging
title: 'Presence'
layout: nil
---

### Notify the Recipient that the Sender is Typing

Call <b>`+[Bit6 typingBeginToAddress:]`</b>. 

If using UITextField to type, utilize its UITextFieldDelegate to send the notification:

```objc
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
                                                       replacementString:(NSString *)string
{
	Bit6Address *otherUserAddress = ...
    [Bit6 typingBeginToAddress:otherUserAddress];
    return YES;
}
```


### Detect when the Recipient is Typing

Register as an observer for typing status:

```objc
    [[NSNotificationCenter defaultCenter] addObserver:self 
      selector:@selector(typingDidBeginRtNotification:) 
         name:Bit6TypingDidBeginRtNotification object:nil];
         
    [[NSNotificationCenter defaultCenter] addObserver:self 
        selector:@selector(typingDidEndRtNotification:) 
           name:Bit6TypingDidEndRtNotification object:nil];
```

Upon receiving a typing notification, update the UI:

```objc
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