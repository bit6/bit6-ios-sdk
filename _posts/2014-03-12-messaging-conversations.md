---
category: messaging
title: 'Conversations'
---

A conversation is interaction between two users, that includes all [text messages](#messaging-plain) and [multimedia messages](#multimedia-messaging-photo) they exchange. There is one conversation per destination address (phone number, e-mail, Facebook account etc).

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
Bit6Address *address = [Bit6Address addressWithUsername:@"user2"];
Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
[Bit6 addConversation:conversation];
```
```objc
//Swift
var address = Bit6Address(username:"user2")
var conversation = Bit6Conversation(address: address)
Bit6.addConversation(conversation)
```
###Delete a Conversation

```objc
//ObjectiveC
Bit6Conversation *conversationToDelete = ...
[Bit6 deleteConversation:conversationToDelete 
		      completion:^(NSDictionary *response, NSError *error) {
		    if (!error) {
		        //conversation deleted
		    }
}];
```
```swift
//Swift
var conversationToDelete : Bit6Conversation = ...
Bit6.deleteConversation(conversationToDelete) { (response, error) in
    if error == nil {
        //conversation deleted
    }
}
```

###Listen to Changes in Conversations

You will need to know when a conversation has been created, deleted or changed (for example, a new message was received within a certain conversation, the conversation title has changed, etc). 

Register as an observer for updates on conversation level:

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(conversationsChangedNotification:)
                           name:Bit6ConversationsChangedNotification
                         object:nil];
```
```swift
//Swift
NSNotificationCenter.defaultCenter().addObserver(self,
										selector:"conversationsChangedNotification:", 
			                                name:Bit6ConversationsChangedNotification, 
			                              object:nil)
```

Upon receiving a conversation change notification, update the conversations array:

```objc
//ObjectiveC
- (void) conversationsChangedNotification:(NSNotification*)notification
{
    Bit6Conversation *conversation = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        //add conversation to self.conversations and refresh changes in UI
    }
    if ([change isEqualToString:Bit6UpdatedKey]) {
        //find conversation in self.conversations and refresh changes in UI
    }
    if ([change isEqualToString:Bit6DeletedKey]) {
        //find conversation in self.conversations, remove it and refresh changes in UI
    }
} 
```
```swift
//Swift
func conversationsChangedNotification(notification:NSNotification){
   let conversation = notification.userInfo[Bit6ObjectKey]
   let change = notification.userInfo[Bit6ChangeKey]
   
   if change == Bit6AddedKey {
       //add conversation to self.conversations and refresh changes in UI
   }
   else if change == Bit6UpdatedKey {
       //find conversation in self.conversations and refresh changes in UI
   }
   else if change == Bit6DeletedKey {
       //find conversation in self.conversations, remove it and refresh changes in UI
   }
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
var badge = conversation.badge
```

When showing a messages UIViewController the following code must be called to mark the messages as read and stop increasing the badge value while in the UIViewController:

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
[Bit6 setCurrentConversation:conversation];
```
```swift
//Swift
var conversation : Bit6Conversation = ...
Bit6.setCurrentConversation(conversation)
```

When you are leaving the messages UIViewController the following code must be called:

```objc
//ObjectiveC
- (void)dealloc {
    [Bit6 setCurrentConversation:nil];
}
```
```swift
//Swift
deinit {
	Bit6.setCurrentConversation(nil)
}
```

To get the unread messages total:

```objc
//ObjectiveC
[Bit6 totalBadge]
```
```swift
//Swift
Bit6.totalBadge()
```

### Get Messages in a Conversation

Although messages do not have to be arranged in conversations, it is frequently convenient to have the messages sorted by destination. More docs on handling conversation [here](#/messaging-conversations).

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
self.messages = conversation.messages;
```
```swift
//Swift
var conversation : Bit6Conversation = ...
self.messages = conversation.messages
```

### Listen to Changes in Messages inside Conversations

To know when a message has been added to a particular conversation, or a message status has been updated, register as an observer for updates on message level:

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(messagesChangedNotification:) 
                                             name:Bit6MessagesChangedNotification
                                           object:conversation];
```
```swift
//Swift
var conversation : Bit6Conversation = ...
NSNotificationCenter.defaultCenter().addObserver(self,
										selector:"messagesChangedNotification:", 
                                            name:Bit6MessagesChangedNotification,
                                          object:conversation)
```

Upon receiving a message change notification, update the conversations array:

```objc
//ObjectiveC
- (void) messagesChangedNotification:(NSNotification*)notification
{
    Bit6Message *message = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        //add message to self.messages and refresh changes in UI
    }
    else if ([change isEqualToString:Bit6UpdatedKey]) {
        //find message in self.messages and refresh changes in UI
    }
    else if ([change isEqualToString:Bit6DeletedKey]) {
        //find message in self.messages, remove it and refresh changes in UI
    }
} 
```
```swift
//Swift
func messagesChangedNotification(notification:NSNotification) 
{
   let message = notification.userInfo[Bit6ObjectKey]
   let change = notification.userInfo[Bit6ChangeKey]
   
   if change == Bit6AddedKey {
       //add message to self.messages and refresh changes in UI
   }
   else if change == Bit6UpdatedKey {
       //find message in self.messages and refresh changes in UI
   }
   else if change == Bit6DeletedKey {
       //find message in self.messages, remove it and refresh changes in UI
   }
}
```