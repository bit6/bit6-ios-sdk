---
category: multimedia messaging
title: 'Menu Controller'
layout: nil
---

Let the user to display a menu popup on a text or multimedia message. This menu can have options like copy the text, forward the message and send again a failed message.

This menu controller is available on Bit6ThumbnailImageView for multimedia messages and on Bit6MessageLabel for text messages.

<img style="max-width:20%" src="images/menu_copy.png"/>
<img style="max-width:20%" src="images/menu_foward.png"/>
<img style="max-width:20%" src="images/menu_failed.png"/>

__Step 1.__ Implement Bit6MenuControllerDelegate

```objc
@interface ChatsTableViewController <Bit6MenuControllerDelegate>

@end
```

```objc
Bit6MessageLabel *textLabel = ...
textLabel.menuControllerDelegate = self;
    
Bit6ThumbnailImageView *imageView = ...
imageView.menuControllerDelegate = self;
```

__Step 2.__ Enable sending of failed messages

To show this action, implement resendFailedMessage:

```objc
- (void) resendFailedMessage:(Bit6OutgoingMessage*)msg
{
    //try to send the message again
    [msg sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        ...
    }];
}
```

__Step 3.__ Enable forward of messages

To show this action, implement forwardMessage:

```objc
- (void) forwardMessage:(Bit6Message*)msg
{
    //we created a copy of the message
    Bit6OutgoingMessage *msg = [Bit6OutgoingMessage outgoingCopyOfMessage:self.messageToForward];
    
    //set the destination and the channel
    Bit6Address *address = ...
    msg.destination = address;
    msg.channel = Bit6MessageChannel_PUSH;

    //send a copy of the message to the new destination
    [msg sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        ...
    }];
}
```