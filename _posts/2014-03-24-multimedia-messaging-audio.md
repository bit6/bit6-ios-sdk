---
category: multimedia messaging
title: 'Audio'
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
[[Bit6 audioRecorder] startRecordingAudioForMessage:message 
                                                   maxDuration: 60 
                                                      delegate: self 
                                                 defaultPrompt: YES
                                                  errorHandler:^(NSError *error) {
    //an error occurred
}];
```
```swift
//Swift
Bit6.audioRecorder().startRecordingAudioForMessage(message, 
										maxDuration: 60, 
                                           delegate: self, 
                                      defaultPrompt: true, 
                                       errorHandler: { (error) -> Void 
                                           in
    //an error occurred
});
```

__Note__ If `defaultPrompt` param is YES then a default UIAlertView will be shown to handle the recording. If NO then you need to provide a custom UI to handle the recording.

To get the length of the current recording: `[Bit6 audioRecorder].duration`

To cancel the recording: `[[Bit6 audioRecorder] cancelRecording]`

To finish the recording: `[[Bit6 audioRecorder] stopRecording]`

To know if there's a recording in process: `[Bit6 audioRecorder].isRecording`

__Step 3.__ Implement the `Bit6AudioRecorderControllerDelegate` and send the message when the recording has been completed.


```objc
//ObjectiveC
@interface ChatsViewController <Bit6AudioRecorderControllerDelegate>

- (void) doneRecorderController:(Bit6AudioRecorderController*)b6rc 
                        message:(Bit6OutgoingMessage*)message
{
    if (message.audioDuration > 1.0) {
        [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
            if (!error) {
                NSLog(@"Message Sent");
            }
            else {
                NSLog(@"Message Failed with Error: %@",error.localizedDescription);
            }
        }];
	}
}
```

```swift
//Swift
class ChatsViewController : Bit6AudioRecorderControllerDelegate

func doneRecorderController(b6rc: Bit6AudioRecorderController!, 
						 message: Bit6OutgoingMessage!) {
	if (message.audioDuration > 1.0) {
        message.sendWithCompletionHandler { (response, error) -> Void in
            if (error == nil) {
                NSLog("Message Sent");
            }
            else {
                NSLog("Message Failed with Error: %@",error.localizedDescription);
            }
        }
    }
}
```

### Play an Audio File

```objc
//ObjectiveC
Bit6Message *message = ...
[[Bit6 audioPlayer] startPlayingAudioFileInMessage:message errorHandler:^(NSError *error) 
{
    //an error occurred
}];
```
```swift
//Swift
var message : Bit6OutgoingMessage() = ...
Bit6.audioPlayer().startPlayingAudioFileInMessage(messages,
							errorHandler: { (error) -> Void 
                            in
    //an error occurred
})
```

To get the length of an audio file in a Bit6Message: `message.audioDuration`

To get the current audio file playing length: `[Bit6 audioPlayer].duration`

To get the audio file playing current time: `[Bit6 audioPlayer].currentTime`

To get the last audio playing Bit6Message: `[Bit6 audioPlayer].messagePlaying`

To know if there's an audio file playing at the moment: `[Bit6 audioPlayer].isPlayingAudioFile`

___Note___. You can listen to the `Bit6AudioPlayingNotification` to update your UI while playing an audio file. 
