---
category: multimedia messaging
title: 'Audio'
layout: nil
---

### Record and Send an Audio File

__Step 1.__ Prepare the message: 

```objc
Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
message.destination = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME 
                                                  value:@"user2"];
message.channel = Bit6MessageChannel_PUSH;
```

__Step 2.__ Start the audio recording:

```objc
[[Bit6AudioRecorderController sharedInstance] startRecordingAudioForMessage:message 
                                    maxDuration:15 delegate:self noMicBlock:^{
    [[[UIAlertView alloc] initWithTitle:@"No Access to Microphone" message:nil 
                               delegate:nil cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil] show];
}];
```

__Step 3.__ Implement the `Bit6AudioRecorderControllerDelegate` and send the message when the recording has been completed.


```objc
@interface ChatsViewController <Bit6AudioRecorderControllerDelegate>
```

```objc
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

### Play an Audio File

```objc
Bit6Message *message = ...
[[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:message];
```
