---
category: authentication
title: 'OAuth'
---

Bit6 integrates with various OAuth1 and OAuth2 providers for simplified user authentication.

See the FBVideoCallsDemo sample project included with the sdk.

### Signin with an OAuth provider

Create a new Bit6 account or login into an existing one. In this example we use [Facebook Login](https://developers.facebook.com/docs/facebook-login/ios/).


```objc
//ObjectiveC
[[Bit6 session] getAuthInfoCompletionHandler:^(NSDictionary *response, NSError *error) {
    if (response[@"facebook"][@"client_id"]){
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends"] fromViewController:self.view.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error || result.isCancelled) {
            	//An Error Ocurred
            }
            else {
                [Bit6.session oauthForProvider:@"facebook" params:@{@"client_id":response[@"facebook"][@"client_id"], @"access_token":[FBSDKAccessToken currentAccessToken].tokenString} completion:^(NSDictionary *response, NSError *error) {
                    if (!error) {
                        //Login Completed
                    }
                    else {
                        //Login Failed
                    }
                }];
            }
        }];
    }
}];
```
```swift
//Swift
Bit6.session().getAuthInfoCompletionHandler(){ (response, error) in
    if let facebook = response["facebook"] as? NSDictionary {
    	let client_id = facebook["client_id"] as! NSString
		let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile","email","user_friends"], fromViewController:self.view.window!.rootViewController) { (result, error) in
            if error != nil || result.isCancelled {
                //An Error Ocurred
            }
            else {
            	Bit6.session().oauthForProvider("facebook", params:["client_id":client_id, "access_token":FBSDKAccessToken.currentAccessToken().tokenString]){ (response, error) in
                    if error == nil {
                        //Login Completed
                    }
                    else {
                        //Login Failed
                    }
                }
            }
        }
    }
}
```

To get a Bit6Address object you can do the following:

```objc
//ObjectiveC
Bit6Address *address = [Bit6Address addressWithFacebookId:friendId];
```
```swift
//Swift
let address = Bit6Address(facebookId:friendId)
```
