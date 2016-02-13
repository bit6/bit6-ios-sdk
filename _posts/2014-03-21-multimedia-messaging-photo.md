---
category: multimedia messaging
title: 'Photo'
---

Let your users exchange photos and pictures.

```objc
//ObjectiveC
UIImage *image = ...
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.image = image;
message.destination = [Bit6Address addressWithUsername:@"user2"];
[message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
    if (!error) {
        //Message Sent
    }
    else {
        //Message Failed
    }
}];
```
```swift
//Swift
var image : UIImage = ...
var message = Bit6OutgoingMessage()
message.image = image
message.destination = Bit6Address(username:"user2")
message.sendWithCompletionHandler{ (response, error) in
    if error == nil {
        //Message Sent
    }
    else {
        //Message Failed
    }
}
```