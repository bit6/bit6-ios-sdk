---
category: basic messaging
title: 'Conversations'
layout: nil
---

A conversation is interaction between two users, that includes all [text messages](#/messaging-plain) and [multimedia messages](#/multimedia-messaging-photo) they exchange. There is one conversation per destination address (phone number, e-mail, Facebook account etc).

NOTE: arranging messages in conversations is optional, but can be very convenient depending on what you need.

###Get Existing Conversations

```objc
NSArray *conversations = [Bit6 conversations];
```

###Add a Conversation

```objc
Bit6Address *address = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME 
                                                   value:@"user2"];
Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
[Bit6 addConversation:conversation];
```

###Delete a Conversation

```objc
Bit6Conversation *conversationToDelete = ...
[Bit6 deleteConversation:conversationToDelete];
```

###Listen to Changes

You will need to know when a conversation has been created, deleted or changed (for example, a new message was received within a certain conversation). 

Register as an observer for updates on conversation level:

```objc
[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(conversationsUpdatedNotification:)
                       name:Bit6ConversationsUpdatedNotification object:nil];
```

Upon receiving a conversation change notification, update the conversations array:

```objc
- (void) conversationsUpdatedNotification:(NSNotification*)notification
{
//get updated conversations
NSArray *conversations = [Bit6Conversation conversations];
} 
```

###Unread Messages Badge
Get the number of unread messages for a particular conversation:

```objc
Bit6Conversation *conversation = ...
NSNumber *badge = conversation.badge;
```

When showing a messages UIViewController the following code must be called to mark the messages as read and stop increasing the badge value while in the UIViewController:

```objc
Bit6Conversation *conversation = ...
conversation.ignoreBadge = YES;
```

When you are leaving the messages UIViewController the following code must be called:

```objc
- (void)dealloc {
    Bit6Conversation *conversation = ...
    conversation.ignoreBadge = NO;
}
```
