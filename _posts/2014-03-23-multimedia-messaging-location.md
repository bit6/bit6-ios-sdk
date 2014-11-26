---
category: multimedia messaging
title: 'Location'
layout: nil
---

In iOS 8 you must add the key NSLocationWhenInUseUsageDescription to your info.plist file. This string is used to specify the reason for accessing the user’s location information.

<img style="max-width:100%" src="images/location_ios8.png"/>

__Step 1.__ Prepare the message: 

```objc
//ObjectiveC
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.destination = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                             value:@"user2"];
message.channel = Bit6MessageChannel_PUSH;
```
```swift
//Swift
var message = Bit6OutgoingMessage()
message.destination = Bit6Address(kind:Bit6AddressKind.USERNAME, 
                                 value:"user2")
message.channel = Bit6MessageChannel.PUSH
```

__Step 2.__ Start the location service:

```objc
//ObjectiveC
[[Bit6CurrentLocationController sharedInstance] startListeningToLocationForMessage:message
						  												delegate:self];
```
```swift
//Swift
Bit6CurrentLocationController.sharedInstance().startListeningToLocationForMessage(message, 
																		  delegate: self)
```

__Step 3.__ Implement the `Bit6CurrentLocationControllerDelegate` and send the message when the location has been obtained

```objc
//ObjectiveC
@interface ChatsViewController <Bit6CurrentLocationControllerDelegate>

- (void) currentLocationController:(Bit6CurrentLocationController*)b6clc 
		  didGetLocationForMessage:(Bit6OutgoingMessage*)message
{
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSLog(@"Message Sent");
        }
        else {
            NSLog(@"Message Failed with Error: %@",error.localizedDescription);
        }
    }];
}

- (void) currentLocationController:(Bit6CurrentLocationController*)b6clc 
				  didFailWithError:(NSError*)error 
                  		   message:(Bit6OutgoingMessage*)message
{
    //an error occurred
}
```
```swift
//Swift
class ChatsViewController : Bit6CurrentLocationControllerDelegate

func currentLocationController(b6clc: Bit6CurrentLocationController!, 
	didGetLocationForMessage message: Bit6OutgoingMessage!)
{
    message.sendWithCompletionHandler { (response, error) -> Void in
        if (error == nil) {
            NSLog("Message Sent");
        }
        else {
            NSLog("Message Failed with Error: %@",error.localizedDescription);
        }
    }
}

func currentLocationController(b6clc: Bit6CurrentLocationController!, 
			  didFailWithError error: NSError!, 
              				 message: Bit6OutgoingMessage!)
{
    //an error occurred
}
```

### Open a Location

```objc
//ObjectiveC
Bit6Message *message = ...

//Open in AppleMaps
[Bit6 openLocationOnMapsFromMessage:msg];

/*
    //Open in GoogleMaps app, if available
    NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?center=%@,%@&zoom=14",
                                 msg.data.lat.description, msg.data.lng.description];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
*/

/*
    //Open in Waze app, if available
    NSString *urlString = [NSString stringWithFormat:@"waze://?ll=%@,%@&navigate=yes", 
                                   msg.data.lat.description, msg.data.lng.description];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
*/
```
```swift
//Swift
var message : Bit6Message = ...

//Open in AppleMaps
Bit6.openLocationOnMapsFromMessage(message)

/*
    //Open in GoogleMaps app, if available
    var urlString = String(format:"comgooglemaps://?center=%@,%@&zoom=14", 
    					   message.data.lat.description, message.data.lng.description)
    var url = NSURL(string: urlString)
    if (UIApplication.sharedApplication().canOpenURL(url!)){
        UIApplication.sharedApplication().openURL(url!)
    }
*/

/*
    //Open in Waze app, if available
    var urlString = String(format:"waze://?ll=%@,%@&navigate=yes",
    					   message.data.lat.description, message.data.lng.description)
    var url = NSURL(string: urlString)
    if (UIApplication.sharedApplication().canOpenURL(url!)){
            UIApplication.sharedApplication().openURL(url!)
    }
*/

```
