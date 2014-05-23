---
category: multimedia messaging
title: 'Video'
layout: nil
---

If you are using <b>`UIImagePickerController`</b> to take/select a video you can do the following in the <b>`UIImagePickerControllerDelegate`</b> method:

```objc
- (void)imagePickerController:(UIImagePickerController *)picker 
             didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// start of your imagePickerController:didFinishPickingMediaWithInfo: method
	
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *) kUTTypeMovie]) {
    	//here we add the video to the message
        message.videoURL = info[UIImagePickerControllerMediaURL];
        
        //if we used the camera to take the video we have to set the cropping times 
        //the user selected in the UIImagePickerController object
        message.videoCropStart = 
               [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        message.videoCropEnd = 
               [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
    }
    
    message.destination = self.conversation.address;
    message.channel = Bit6MessageChannel_PUSH;
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSLog(@"Message Sent");
        }
        else {
            NSLog(@"Message Failed with Error: %@",error.localizedDescription);
        }
    }];
    
    // The rest of your imagePickerController:didFinishPickingMediaWithInfo: method
}
```
