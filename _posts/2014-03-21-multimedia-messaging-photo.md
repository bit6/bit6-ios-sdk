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
message.destination = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                             value:@"user2"];
[message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
    if (!error) {
        NSLog(@"Message Sent");
    }
    else {
        NSLog(@"Message Failed with Error: %@",error.localizedDescription);
    }
}];
```
```swift
//Swift
var image : UIImage = ...
var message = Bit6OutgoingMessage()
message.image = image
message.destination = Bit6Address(kind:.USERNAME, 
                                 value:"user2")
message.sendWithCompletionHandler{ (response, error) in
    if error == nil {
        NSLog("Message Sent")
    }
    else {
        NSLog("Message Failed with Error: \(error.localizedDescription)")
    }
}
```