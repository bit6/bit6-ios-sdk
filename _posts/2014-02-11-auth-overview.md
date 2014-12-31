---
category: authentication
title: 'Overview'
---
Each user in the system has one or more identities - user id, username, email, facebook id, google account, phone number etc. Identities are required for user authentication, managing contacts, identifying user's network. An identity is represented by a URI.

Bit6 supports various authentication mechanisms described in the following sections. 


### Check if the user is logged in

```objc
//ObjectiveC
if ([Bit6Session isConnected]) {
    NSLog(@"Active Session");
}
else {
    NSLog(@"Not Active Session");
}
```

```swift
//Swift
if (Bit6Session.isConnected()) {
    NSLog("Active Session");
}
else {
    NSLog("Not Active Session");
}
```


### Logout

```objc
//ObjectiveC
[Bit6Session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
    NSLog(@"Logout Completed");
}];
```

```swift
//Swift
Bit6Session.logoutWithCompletionHandler({(response,error) in            
    NSLog("Logout Completed")
})
```

