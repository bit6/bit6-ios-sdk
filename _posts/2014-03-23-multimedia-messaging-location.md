---
category: multimedia messaging
title: 'Location'
---

In iOS 8 you must add the key NSLocationWhenInUseUsageDescription to your info.plist file. This string is used to specify the reason for accessing the user’s location information.

<img class="shot" src="images/location_ios8.png"/>

__Step 1.__ Prepare the message: 

```objc
//ObjectiveC
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.destination = [Bit6Address addressWithUsername:@"user2"];
```
```swift
//Swift
var message = Bit6OutgoingMessage()
message.destination = Bit6Address(username:"user2")
```

__Step 2.__ Start the location service:

```objc
//ObjectiveC
[[Bit6 locationController] startListeningToLocationForMessage:message delegate:self];
```
```swift
//Swift
Bit6.locationController().startListeningToLocationForMessage(message, delegate: self)
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
            //Message Sent
        }
        else {
            //Message Failed
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
    message.sendWithCompletionHandler{ (response, error) in
        if error == nil {
            //Message Sent
        }
        else {
            //Message Failed
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

### Send a Custom Location

__Note.__ Remember to import the CoreLocation framework.

```objc
//ObjectiveC
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.location = CLLocationCoordinate2DMake(latitude, longitude);
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
message.location = CLLocationCoordinate2DMake(latitude, longitude)
message.destination = Bit6Address(username:"user2")
message.sendWithCompletionHandler{ (response, error) in
    if error == nil {
        //Message Sent
    }
    else {
        //Message Failed
    }
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
    CLLocationCoordinate2D location = msg.location;
    NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14",
                                 location.latitude, location.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
*/

/*
    //Open in Waze app, if available
    CLLocationCoordinate2D location = msg.location;
    NSString *urlString = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes", 
                                   location.latitude, location.longitude];
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
    let location = msg.location
    let urlString = "comgooglemaps://?center=\(location.latitude),\(location.longitude)&zoom=14"
    let url = NSURL(string: urlString)
    if UIApplication.sharedApplication().canOpenURL(url!) {
        UIApplication.sharedApplication().openURL(url!)
    }
*/

/*
    //Open in Waze app, if available
    let location = msg.location
    let urlString = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
    let url = NSURL(string: urlString)
    if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
    }
*/

```
