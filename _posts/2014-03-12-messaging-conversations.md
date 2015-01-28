---
category: messaging
title: 'Conversations'
---

A conversation is interaction between two users, that includes all [text messages](#/messaging-plain) and [multimedia messages](#/multimedia-messaging-photo) they exchange. There is one conversation per destination address (phone number, e-mail, Facebook account etc).

NOTE: arranging messages in conversations is optional, but can be very convenient depending on what you need.

###Get Existing Conversations

```objc
//ObjectiveC
NSArray *conversations = [Bit6 conversations];
```
```swift
//Swift
var conversations = Bit6.conversations()
```

###Add a Conversation

```objc
//ObjectiveC
Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                              value:@"user2"];
Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
[Bit6 addConversation:conversation];
```
```objc
//Swift
var address = Bit6Address(kind:Bit6AddressKind.USERNAME, 
						 value:"user2")
var conversation = Bit6Conversation(address: address)
Bit6.addConversation(conversation)
```
###Delete a Conversation

```objc
//ObjectiveC
Bit6Conversation *conversationToDelete = ...
[Bit6 deleteConversation:conversationToDelete];
```
```swift
//Swift
var conversationToDelete : Bit6Conversation = ...
Bit6.deleteConversation(conversationToDelete)
```

###Listen to Changes

You will need to know when a conversation has been created, deleted or changed (for example, a new message was received within a certain conversation). 

Register as an observer for updates on conversation level:

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(conversationsUpdatedNotification:)
                       name:Bit6ConversationsUpdatedNotification 
                       object:nil];
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver(self,
							selector:"conversationsUpdatedNotification:", 
                                name: Bit6ConversationsUpdatedNotification, 
                              object: nil)
```

Upon receiving a conversation change notification, update the conversations array:

```objc
//ObjectiveC
- (void) conversationsUpdatedNotification:(NSNotification*)notification
{
//get updated conversations
self.conversations = [Bit6Conversation conversations];
} 
```
```swift
//Swift
func conversationsUpdatedNotification(notification:NSNotification){
//get updated conversations
self.conversations = Bit6.conversations()
}
```

###Unread Messages Badge
Get the number of unread messages for a particular conversation:

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
NSNumber *badge = conversation.badge;
```
```swift
//Swift
var conversation : Bit6Conversation = ...
var badge = conversation.badge;
```

When showing a messages UIViewController the following code must be called to mark the messages as read and stop increasing the badge value while in the UIViewController:

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
conversation.ignoreBadge = YES;
```
```swift
//Swift
var conversation : Bit6Conversation = ...
conversation.ignoreBadge = true;
```

When you are leaving the messages UIViewController the following code must be called:

```objc
//ObjectiveC
- (void)dealloc {
    Bit6Conversation *conversation = ...
    conversation.ignoreBadge = NO;
}
```
```swift
//Swift
deinit {
    var conversation : Bit6Conversation = ...
    conversation.ignoreBadge = false;
}
```