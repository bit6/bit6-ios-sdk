---
category: multimedia messaging
title: 'Audio'
---

### Record and Send an Audio File

__Step 1.__ Start the audio recording:

```objc
//ObjectiveC
[[Bit6 audioRecorder] startRecordingAudioWithMaxDuration: 60 
                                                delegate: self 
                                           defaultPrompt: YES
                                            errorHandler:^(NSError *error) {
    //an error occurred
}];
```
```swift
//Swift
Bit6.audioRecorder().startRecordingAudioWithMaxDuration(60, 
                                           	   delegate: self, 
                                      	  defaultPrompt: true, 
                                       	   errorHandler: { (error) in
    //an error occurred
});
```

__Note__ If `defaultPrompt` param is YES then a default UIAlertView will be shown to handle the recording. If NO then you need to provide a custom UI to handle the recording.

To get the length of the current recording: `[Bit6 audioRecorder].duration`. Then you can use `[Bit6Utils clockFormatForSeconds:duration]` to get a string like 01:05.

To cancel the recording: `[[Bit6 audioRecorder] cancelRecording]`

To finish the recording: `[[Bit6 audioRecorder] stopRecording]`

To know if there's a recording in process: `[Bit6 audioRecorder].isRecording`

__Step 2.__ Implement the `Bit6AudioRecorderControllerDelegate`. Its methods are called in the main thread.


```objc
//ObjectiveC
@interface ChatsViewController <Bit6AudioRecorderControllerDelegate>

- (void) doneRecorderController:(Bit6AudioRecorderController*)b6rc 
                       filePath:(NSString*)filePath
{
    if ([Bit6Utils audioDurationForFileAtPath:filePath] > 1.0) {
    	Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
		message.destination = [Bit6Address addressWithUsername:@"user2"];
		message.audioFilePath = filePath;
        [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
            if (!error) {
                //Message Sent
            }
            else {
                //Message Failed
            }
        }];
	}
}

- (void)isRecordingWithController:(Bit6AudioRecorderController*)b6rc 
						 filePath:(NSString*)filePath
{
	//called each 0.5 seconds while recording
	double durationValue = [Bit6 audioRecorder].duration;
	NSString *duration = [Bit6Utils clockFormatForSeconds:durationValue];
}

- (void)cancelRecorderController:(Bit6AudioRecorderController*)b6rc
{
	//the recording was cancelled
}
```

```swift
//Swift
class ChatsViewController : Bit6AudioRecorderControllerDelegate

func doneRecorderController(b6rc: Bit6AudioRecorderController, 
						 filePath: NSString) {
	if Bit6Utils.audioDurationForFileAtPath(filePath) > 1.0 {
		var message = Bit6OutgoingMessage()
		message.destination = Bit6Address(username:"user2")
		message.audioFilePath = filePath
        message.sendWithCompletionHandler{ (response, error) in
            if error == nil {
                //Message Sent
            }
            else {
                //Message Failed
            }
        }
    }
}

func isRecordingWithController(b6rc: Bit6AudioRecorderController, 
						   filePath: NSString) {
	//called each 0.5 seconds while recording
	if let durationValue = Bit6.audioRecorder().duration {
		let duration = Bit6Utils.clockFormatForSeconds(durationValue)
	}
}

func cancelRecorderController(b6rc: Bit6AudioRecorderController) {
	//the recording was cancelled
}
```

### Play an Audio File

```objc
//ObjectiveC
NSString *filePath = message.pathForFullAttachment;
[[Bit6 audioPlayer] startPlayingAudioFileAtPath:filePath errorHandler:^(NSError *error) 
{
    //an error occurred
}];
```
```swift
//Swift
var message : Bit6OutgoingMessage() = ...
let filePath = message.pathForFullAttachment
Bit6.audioPlayer().startPlayingAudioFileAtPath(filePath,
							errorHandler: { (error) in
    //an error occurred
})
```

To get the length of an audio file in a Bit6Message: `message.audioDuration`

To get the current audio file playing length: `[Bit6 audioPlayer].duration`

To get the audio file playing current time: `[Bit6 audioPlayer].currentTime`

To get the path to the last audio file played: `[Bit6 audioPlayer].filePathPlaying`

To know if there's an audio file playing at the moment: `[Bit6 audioPlayer].isPlayingAudioFile`

___Note___. You can listen to the `Bit6AudioPlayingNotification` to update your UI while playing an audio file. 
