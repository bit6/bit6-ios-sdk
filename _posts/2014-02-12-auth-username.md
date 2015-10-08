---
category: authentication
title: 'Username'
---

A username is case-insensitive and must consist of alphanumeric characters, e.g. `usr:john` or  `usr:test123`.

### Create user account

Create a new user account with a username identity and a password.

```objc
//ObjectiveC
NSString *name = @"john";
NSString *pass = @"secret";

Bit6Address *i = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                        value:name];

[[Bit6 session] signUpWithUserIdentity:i
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
var name = "john"
var pass = "secret"

var i = Bit6Address(kind: .USERNAME, 
				   value: name)
                   
Bit6.session().signUpWithUserIdentity(i, password:pass){ (response,error) in
    if error != nil {
        NSLog("Sign Up Failed With Error: \(error.localizedDescription)")
    }
    else {
	    NSLog("Sign Up Completed")
    }
}
```

### Login

Login into an existing account using an Identity and a password.

```objc
//ObjectiveC
NSString *name = @"john";
NSString *pass = @"secret";

Bit6Address *i = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                        value:name];
[[Bit6 session] loginWithUserIdentity:i 
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

var i = Bit6Address(kind: .USERNAME, 
				   value: name)
                   
Bit6.session().loginWithUserIdentity(i, password: pass){ (response,error) in
    if error != nil {
        NSLog("Login Failed With Error: \(error.localizedDescription)")
    }
    else {
        NSLog("Login Completed")
    }
}
```
