---
category: messaging
title: 'Text Messages'
---

### Send Text Message

```objc
//ObjectiveC
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.content = @"This is a text message";
message.destination = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
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
```swift
//Swift
var message = Bit6OutgoingMessage()
message.content = "This is a text message"
message.destination = Bit6Address(kind: .USERNAME, 
                   				 value: "user2");
message.channel = .PUSH;
message.sendWithCompletionHandler { (response, error) -> Void in
    if (error == nil) {
        NSLog("Message Sent");
    }
    else {
        NSLog("Message Failed with Error: %@",error.localizedDescription);
    }
}
```

### Get Messages

```objc
//ObjectiveC
NSArray *messages = [Bit6 messagesWithOffset:0 length:NSIntegerMax asc:YES];
```
```swift
//Swift
var messages = Bit6.messagesWithOffset(0, length: NSIntegerMax, asc: true)
```


### Listen to Changes in Messages 

To know when a message has been added or a message status has been updated, register as an observer for updates on message level:

```objc
//ObjectiveC
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(messagesUpdatedNotification:) 
                                             name:Bit6MessagesUpdatedNotification 
                                           object:nil];
```
```swift
//Swift
var conversation : Bit6Conversation = ...
NSNotificationCenter.defaultCenter().addObserver(self,
										selector:"messagesUpdatedNotification:", 
                                            name: Bit6MessagesUpdatedNotification,
                                          object: nil)
```

Upon receiving a message change notification, update the conversations array:

```objc
//ObjectiveC
- (void) messagesUpdatedNotification:(NSNotification*)notification
{
    //get updated messages
    self.messages = [Bit6 messagesWithOffset:0 length:NSIntegerMax asc:YES];
} 
```
```swift
//Swift
func messagesUpdatedNotification(notification:NSNotification)
{
    //get updated messages
    self.messages = Bit6.messagesWithOffset(0, length: NSIntegerMax, asc: true)
}
```

### Get Messages in a Conversation

Although messages do not have to be arranged in conversations, it is frequently convenient to have the messages sorted by destination. More docs on handling conversation [here](#/messaging-conversations).

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
NSArray *messages = conversation.messages;
```
```swift
//Swift
var conversation : Bit6Conversation = ...
var messages = conversation.messages
```

### Handle Message Updates

To know when a message has been added to a particular conversation, or a message status has been updated, register as an observer for updates on message level:

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(messagesUpdatedNotification:) 
                                             name:Bit6MessagesUpdatedNotification 
                                           object:conversation];
```
```swift
//Swift
var conversation : Bit6Conversation = ...
NSNotificationCenter.defaultCenter().addObserver(self,
										selector:"messagesUpdatedNotification:", 
                                            name: Bit6MessagesUpdatedNotification,
                                          object: self.conversation)
```

Upon receiving a message change notification, update the conversations array:

```objc
//ObjectiveC
- (void) messagesUpdatedNotification:(NSNotification*)notification
{
    Bit6Conversation *conversation = (Bit6Conversation *)notification.object;
    //get updated messages
    self.messages = conversation.messages;
} 
```
```swift
//Swift
func messagesUpdatedNotification(notification:NSNotification) 
{
	var conversation : Bit6Conversation = notification.object as Bit6Conversation
    //get updated messages
    self.messages = conversation.messages
}
```

###Delete a Message

```objc
//ObjectiveC
Bit6Message *messageToDelete = ...
[Bit6 deleteMessage:messageToDelete];
```

```swift
//Swift
var messageToDelete : Bit6Message = ...
Bit6.deleteMessage(messageToDelete)
```

###Enable Background Push Notifications for Messages

You can enable background remote notifications by checking the property in your target configuration.

<img class="shot" src="images/background_notifications.png"/>

Then in your Bit6ApplicationManager subclass you need to implement the following:

```objc
//ObjectiveC
- (void)application:(UIApplication *)application 
		didReceiveRemoteNotification:(NSDictionary *)userInfo 
        	  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [super didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
```

```swift
func application(application: UIApplication, 
		didReceiveRemoteNotification userInfo: [NSObject : AnyObject], 
     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) 
{
    super.didReceiveRemoteNotification(userInfo, fetchCompletionHandler:completionHandler);
}
```