---
category: multimedia messaging
title: 'Photo'
layout: nil
---

Let your users exchange photos and pictures.

```objc
UIImage *image = ...
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.image = image;
message.destination = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME 
                                                  value:@"user2"];
message.channel = Bit6MessageChannel_PUSH;
[message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
    if (!error) {
        NSLog(@"Message Sent");
    }
    else {
        NSLog(@"Message Failed with Error: %@",error.localizedDescription);
    }
}];
```
