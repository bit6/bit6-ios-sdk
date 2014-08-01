---
category: basic messaging
title: 'Text Messages'
layout: nil
---

### Send Text Message

```objc
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.content = @"This is a text message";
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

### Get Messages

```objc
NSArray *messages = [Bit6 messagesWithOffset:0 length:NSIntegerMax asc:YES];
```

### Listen to Changes in Messages 

To know when a message has been added or a message status has been updated, register as an observer for updates on message level:

```objc
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(messagesUpdatedNotification:) 
                                             name:Bit6MessagesUpdatedNotification 
                                           object:nil];
```

Upon receiving a message change notification, update the conversations array:

```objc
- (void) messagesUpdatedNotification:(NSNotification*)notification
{
//get updated messages
NSArray *messages = [Bit6 messagesWithOffset:0 length:NSIntegerMax asc:YES];
} 
```

### Get Messages in a Conversation

Although messages do not have to be arranged in conversations, it is frequently convenient to have the messages sorted by destination. More docs on handling conversation [here](#/messaging-conversations).

```objc
Bit6Conversation *conversation = ...
NSArray *messages = conversation.messages;
```

### Handle Message Updates

To know when a message has been added to a particular conversation, or a message status has been updated, register as an observer for updates on message level:

```objc
Bit6Conversation *conversation = ...
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(messagesUpdatedNotification:) 
                                             name:Bit6MessagesUpdatedNotification 
                                           object:conversation];
```

Upon receiving a message change notification, update the conversations array:

```objc
- (void) messagesUpdatedNotification:(NSNotification*)notification
{
Bit6Conversation *conversation = (Bit6Conversation *)notification.object;
//get updated messages
NSArray *messages = conversation.messages;
} 
```

###Delete a Message

```objc
Bit6Message *messageToDelete = ...
[Bit6 deleteMessage:messageToDelete];
```

### Multimedia Messaging

Click [here](#/messaging-multimedia) for the multimedia messaging docs.