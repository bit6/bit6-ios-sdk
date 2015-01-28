---
category: authentication
title: 'OAuth'
---

Bit6 integrates with various OAuth1 and OAuth2 providers for simplified user authentication.

### Signin with an OAuth provider

Create a new Bit6 account or login into an existing one. In this example we use [Facebook Login](https://developers.facebook.com/docs/facebook-login/ios/).


```objc
//ObjectiveC
[[Bit6 session] getAuthInfoCompletionHandler:^(NSDictionary *response, NSError *error) {
    if (response[@"facebook"][@"client_id"]){
        [[FBSession activeSession] closeAndClearTokenInformation];
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email",@"user_friends"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            if (state==FBSessionStateOpen) {
                [[Bit6 session] oauthForProvider:Bit6SessionProvider_FACEBOOK params:@{@"client_id":response[@"facebook"][@"client_id"], @"access_token":FBSession.activeSession.accessTokenData.accessToken} completion:^(NSDictionary *response, NSError *error) {
                    if (error==nil) {
                        NSLog("Login Failed With Error: %s",error.localizedDescription);
                    }
                    else {
                        NSLog("Login Completed");
                    }
                }];
            }
        }];
    }
}];
```
```swift
//Swift
Bit6.session().getAuthInfoCompletionHandler({ (response, error) -> Void in
    if (response["facebook"] != nil) {

        var facebook = response["facebook"] as NSDictionary;
        var client_id = facebook["client_id"] as NSString;

        FBSession.activeSession().closeAndClearTokenInformation();
        FBSession.openActiveSessionWithReadPermissions(["public_profile","email","user_friends"], allowLoginUI: true, completionHandler: { (session, state, error) -> Void in
            if (state == FBSessionState.Open){
                Bit6.session().oauthForProvider(Bit6SessionProvider.FACEBOOK, params:["client_id":client_id, "access_token":FBSession.activeSession().accessTokenData.accessToken], completion: { (response, error) -> Void
                    in
                        if ((error) != nil){
                            NSLog("Login Failed With Error: %s",error.localizedDescription);
                        }
                        else {
                            NSLog("Login Completed");
                        }
                    })
            }
        });
    }
});
```

To get an Bit6Address object you can do the following:

```objc
//ObjectiveC
Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_FACEBOOK value:friendId];
```
```swift
//Swift
var address = Bit6Address(kind: Bit6AddressKind.FACEBOOK, value:friendId)
```
