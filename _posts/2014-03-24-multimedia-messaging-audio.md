---
category: multimedia messaging
title: 'Audio'
layout: nil
---

### Record and Send an Audio File

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

__Step 2.__ Start the audio recording:

```objc
//ObjectiveC
[[Bit6AudioRecorderController sharedInstance] startRecordingAudioForMessage:message 
                                                    maxDuration:60 delegate:self 
                                                   errorHandler:^(NSError *error) {
    //an error occurred
}];
```
```swift
//Swift
Bit6AudioRecorderController.sharedInstance().startRecordingAudioForMessage(message, 
										maxDuration: 60, 
                                           delegate: self) { (error) -> Void 
                                           in
    //an error occurred
}
```

__Step 3.__ Implement the `Bit6AudioRecorderControllerDelegate` and send the message when the recording has been completed.


```objc
//ObjectiveC
@interface ChatsViewController <Bit6AudioRecorderControllerDelegate>

- (void) doneRecorderController:(Bit6AudioRecorderController*)b6rc 
                        message:(Bit6OutgoingMessage*)message
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
```

```swift
//Swift
class ChatsViewController : Bit6AudioRecorderControllerDelegate

func doneRecorderController(b6rc: Bit6AudioRecorderController!, 
						 message: Bit6OutgoingMessage!) {
    message.sendWithCompletionHandler { (response, error) -> Void in
        if (error == nil) {
            NSLog("Message Sent");
        }
        else {
            NSLog("Message Failed with Error: %@",error.localizedDescription);
        }
    }
}
```

### Play an Audio File

```objc
//ObjectiveC
Bit6Message *message = ...
[[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:message 
                                                            errorHandler:^(NSError *error) 
{
    //an error occurred
}];
```
```swift
//Swift
var message : Bit6OutgoingMessage() = ...
Bit6AudioPlayerController.sharedInstance().startPlayingAudioFileInMessage(messages,
							errorHandler: { (error) -> Void 
                            in
    //an error occurred
})
```
