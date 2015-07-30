---
category: authentication
title: 'Session'
---
Each user in the system has one or more identities - user id, username, email, facebook id, google account, phone number etc. Identities are required for user authentication, managing contacts, identifying user's network. An identity is represented by a URI.

Bit6 supports various authentication mechanisms described in the following sections. 


### Check if the user is authenticated

```objc
//ObjectiveC
if ([Bit6 session].authenticated) {
    NSLog(@"Active Session");
}
else {
    NSLog(@"Not Active Session");
}
```

```swift
//Swift
if (Bit6.session().authenticated {
    NSLog("Active Session");
}
else {
    NSLog("Not Active Session");
}
```


### Logout

```objc
//ObjectiveC
[[Bit6 session] logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
	if (! error) {
		NSLog(@"Logout Completed");
	}
}];
```

```swift
//Swift
Bit6.session().logoutWithCompletionHandler({(response,error) in 
	if (error != nil) {
		NSLog("Logout Completed")
	}
})
```

### Listening to Login and Logout Notifications

```objc
//ObjectiveC

[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(loginCompletedNotification:) 
                                             name:Bit6LoginCompletedNotification
                                           object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(logoutCompletedNotification:) 
                                             Bit6LogoutCompletedNotification
                                           object:nil];

- (void) loginCompletedNotification:(NSNotification*)notification
{

}

- (void) logoutCompletedNotification:(NSNotification*)notification
{

}

```
```swift
//Swift

NSNotificationCenter.defaultCenter().addObserver(self, 
										selector: "loginCompletedNotification:", 
											name: Bit6LoginCompletedNotification, 
										  object: nil)

NSNotificationCenter.defaultCenter().addObserver(self, 
										selector: "logoutStartedNotification:", 
											name: Bit6LogoutStartedNotification, 
										  object: nil)

func loginCompletedNotification(notification:NSNotification)
{

}

func logoutStartedNotification(notification:NSNotification)
{

}
```

