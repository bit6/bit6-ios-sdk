---
category: multimedia messaging
title: 'Menu Controller'
---

Implement a menu popup to enable message forwarding, resending and text copying.

This menu controller is available in Bit6ThumbnailImageView for multimedia messages and in Bit6MessageLabel for text messages.

<img style="max-width:20%" src="images/menu_copy.png"/>
<img style="max-width:20%" src="images/menu_foward.png"/>
<img style="max-width:20%" src="images/menu_failed.png"/>

__Step 1.__ Implement Bit6MenuControllerDelegate

```objc
//ObjectiveC
@interface ChatsTableViewController <Bit6MenuControllerDelegate>

@end

Bit6MessageLabel *textLabel = ...
textLabel.message = message;
textLabel.menuControllerDelegate = self;
    
Bit6ThumbnailImageView *imageView = ...
imageView.message = message;
imageView.menuControllerDelegate = self;
```



```swift
//Swift
class ChatsTableViewController :Bit6MenuControllerDelegate {

}

var textLabel : Bit6MessageLabel = ...
textLabel.message = message
textLabel.menuControllerDelegate = self
    
var imageView : Bit6ThumbnailImageView = ...
imageView.message = message;
imageView.menuControllerDelegate = self;
```

__Step 2.__ Enable resending of failed messages

To show this action, implement resendFailedMessage:

```objc
//ObjectiveC
- (void) resendFailedMessage:(Bit6OutgoingMessage*)msg
{
    //try to send the message again
    [msg sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        ...
    }];
}
```

```swift
//Swift
func resendFailedMessage(msg:Bit6OutgoingMessage){
    //try to send the message again
    msg.sendWithCompletionHandler ({ (response, error) -> Void in
        ...
    })
}
```

__Step 3.__ Enable message forwarding

To show this action, implement forwardMessage:

```objc
//ObjectiveC
- (void) forwardMessage:(Bit6Message*)msg
{
    //we create a copy of the message
    Bit6OutgoingMessage *messageToForward = [Bit6OutgoingMessage outgoingCopyOfMessage:msg];
    
    //set the destination and the channel
    Bit6Address *address = ...
    messageToForward.destination = address;

    //send a copy of the message to the new destination
    [messageToForward sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        ...
    }];
}
```
```swift
//Swift
func forwardMessage(msg:Bit6Message)
{
    //we create a copy of the message
    var messageToForward = Bit6OutgoingMessage.outgoingCopyOfMessage(msg)
    
    //set the destination and the channel
    var address : Bit6Address = ...
    messageToForward.destination = address

    //send a copy of the message to the new destination
    messageToForward.sendWithCompletionHandler ({ (response, error) -> Void in
        ...
    }
})
```