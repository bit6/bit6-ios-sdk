---
category: multimedia messaging
title: 'Location'
layout: nil
---

__Step 1.__ Prepare the message: 

```objc
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.destination = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME 
                                                  value:@"user2"];
message.channel = Bit6MessageChannel_PUSH;
```

__Step 2.__ Start the location service:

```objc
[[Bit6CurrentLocationController sharedInstance] startListeningToLocationForMessage:message 
                                                                          delegate:self];
```

__Step 3.__ Implement the `Bit6CurrentLocationControllerDelegate` and send the message when the location has been obtained

```objc
@interface ChatsViewController <Bit6CurrentLocationControllerDelegate>
```

```objc
- (void) currentLocationController:(Bit6CurrentLocationController*)b6clc didGetLocationForMessage:(Bit6OutgoingMessage*)message
{
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSLog(@"Message Sent");
        }
        else {
            NSLog(@"Message Failed with Error: %@",error.localizedDescription);
        }
    }];
}

- (void) currentLocationController:(Bit6CurrentLocationController*)b6clc didFailWithError:(NSError*)error message:(Bit6OutgoingMessage*)message
{
    //show an error message
}
```
