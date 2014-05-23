---
title: 'Authentication'
layout: nil
---

### Create user account

Create a new user account with a username identity.

```objc
NSString *name = @"john";
NSString *pass = @"secret";

Bit6Address *i = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME 
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

### Login

Login into an existing account using an Identity and a password.

```objc
NSString *name = @"john";
NSString *pass = @"secret";

Bit6Address *i = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME
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

### Logout

```objc
[Bit6Session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
    NSLog(@"Logout Completed");
}];
```

### Check if the user is logged in

```objc
if ([Bit6Session isConnected]) {
    NSLog(@"Active Session");
}
else {
    NSLog(@"Not Active Session");
}
```
