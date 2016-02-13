---
category: messaging
title: 'Text Messages'
---

### Send Text Message

```objc
//ObjectiveC
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.content = @"This is a text message";
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
var message = Bit6OutgoingMessage()
message.content = "This is a text message"
message.destination = Bit6Address(username:"user2")

message.sendWithCompletionHandler { (response, error) in
    if error == nil {
        //Message Sent
    }
    else {
        //Message Failed
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
                                         selector:@selector(messagesChangedNotification:) 
                                             name:Bit6MessagesChangedNotification 
                                           object:nil];
```
```swift
//Swift
var conversation : Bit6Conversation = ...
NSNotificationCenter.defaultCenter().addObserver(self,
										selector:"messagesChangedNotification:", 
                                            name:Bit6MessagesChangedNotification,
                                          object:nil)
```

Upon receiving a message change notification, update the messages array:

```objc
//ObjectiveC
- (void) messagesChangedNotification:(NSNotification*)notification
{
    Bit6Message *msg = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        //add message to self.messages and refresh changes in UI
    }
    else if ([change isEqualToString:Bit6UpdatedKey]) {
        //find message in self.messages and refresh changes in UI
    }
    else if ([change isEqualToString:Bit6DeletedKey]) {
        //find message in self.messages, delete it and refresh changes in UI
    }
} 
```
```swift
//Swift
func messagesChangedNotification(notification:NSNotification)
{
   let msg = notification.userInfo[Bit6ObjectKey]
   let change = notification.userInfo[Bit6ChangeKey]
   
   if change == Bit6AddedKey {
       //add message to self.messages and refresh changes in UI
   }
   else if change == Bit6UpdatedKey {
       //find message in self.messages and refresh changes in UI
   }
   else if change == Bit6DeletedKey {
       //find message in self.messages, delete it and refresh changes in UI
   }
}
```

###Delete a Message

```objc
//ObjectiveC
Bit6Message *messageToDelete = ...
[Bit6 deleteMessage:messageToDelete 
		 completion:^(NSDictionary *response, NSError *error) {
		    if (!error) {
		        //message deleted
		    }
}];
```

```swift
//Swift
var messageToDelete : Bit6Message = ...
Bit6.deleteMessage(messageToDelete) { (response, error) in
    if error == nil {
        //message deleted
    }
}
```

###Enable Background Push Notifications for Messages

You can enable background remote notifications by checking the property in your target configuration.

<img class="shot" src="images/background_notifications.png"/>

Then in your UIApplicationDelegate implementation you need to add the following:

```objc
//ObjectiveC
- (void)application:(UIApplication *)application 
		didReceiveRemoteNotification:(NSDictionary *)userInfo 
        	  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [[Bit6 pushNotification] didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
```

```swift
//Swift
func application(application: UIApplication, 
		didReceiveRemoteNotification userInfo: [NSObject : AnyObject], 
     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) 
{
	Bit6.pushNotification().didReceiveRemoteNotification(userInfo, fetchCompletionHandler:completionHandler)
}
```

#####Note. If you implement `application:didReceiveRemoteNotification:fetchCompletionHandler:` remember to remove this from your `application:didFinishLaunchingWithOptions:`

```objc
//ObjectiveC
//Remove
/*
	NSDictionary *remoteNotificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
	if (remoteNotificationPayload) {
	    //[[Bit6 pushNotification] didReceiveRemoteNotification:remoteNotificationPayload];
	}
*/
```
```swift
//Swift
//Remove
/*
	if let remoteNotificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
        Bit6.pushNotification().didReceiveRemoteNotification(remoteNotificationPayload as [NSObject : AnyObject])
    }
*/
```