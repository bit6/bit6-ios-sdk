---
title: 'Authentication'
layout: nil
---

### Create user account

Create a new user account with a username identity.

```objc
//ObjectiveC
NSString *name = @"john";
NSString *pass = @"secret";

Bit6Address *i = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                        value:name];

[Bit6Session signUpWithUserIdentity:i
                           password:pass 
                  completionHandler:^(NSDictionary *response, NSError *error) {
    if (!error) {
        NSLog(@"Sign Up Completed");
    }
    else {
        NSLog(@"Sign Up Failed With Error: %@",error.localizedString);
    }
}];
```

```swift
//Swift
var name = "john";
var pass = "secret";

var i = Bit6Address(kind: Bit6AddressKind.USERNAME, 
				   value: name);
                   
Bit6Session.signUpWithUserIdentity(i, 
						  password:pass, 
                 completionHandler:{(response,error) in
    if (error != nil){
        NSLog("Sign Up Failed With Error: %s",error.localizedDescription);
    }
    else {
	    NSLog("Sign Up Completed");
    }
});
```

### Login

Login into an existing account using an Identity and a password.

```objc
//ObjectiveC
NSString *name = @"john";
NSString *pass = @"secret";

Bit6Address *i = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                        value:name];
[Bit6Session loginWithUserIdentity:i 
                          password:pass 
                 completionHandler:^(NSDictionary *response, NSError *error) {
    if (!error) {
        NSLog(@"Login Completed");
    }
    else {
        NSLog(@"Login failed with error: %@",error.localizedString);
    }
}];
```

```swift
//Swift
var name = "john";
var pass = "secret";

var i = Bit6Address(kind: Bit6AddressKind.USERNAME, 
				   value: name);
                   
Bit6Session.loginWithUserIdentity(i, 
						 password: pass, 
				completionHandler:{(response,error) in
    if (error != nil){
        NSLog("Login Failed With Error: %s",error.localizedDescription);
    }
    else {
        NSLog("Login Completed");
    }
});
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
