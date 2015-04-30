---
category: multimedia messaging
title: 'Video'
---

If you are using `UIImagePickerController` to take/select a video you can do the following in the `UIImagePickerControllerDelegate` method:

```objc
//ObjectiveC
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
        message.videoCropStart = 
               [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        message.videoCropEnd = 
               [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
    }
    
    message.destination = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME 
                                                 value:@"user2"];
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
```swift
//Swift
func imagePickerController(picker: UIImagePickerController,
didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
{
	// start of your imagePickerController:didFinishPickingMediaWithInfo: method
	
    var message = Bit6OutgoingMessage()
    
    var mediaType = info[UIImagePickerControllerMediaType] as NSString
    if (mediaType.isEqualToString(kUTTypeMovie)) {
    	//here we add the video to the message
        message.videoURL = info[UIImagePickerControllerMediaURL] as NSURL
        
        //if we used the camera to take the video we have to set the cropping times 
        message.videoCropStart = 
               info["_UIImagePickerControllerVideoEditingStart"] as NSNumber
        message.videoCropEnd = 
               info["_UIImagePickerControllerVideoEditingEnd"] as NSNumber
    }
    
	message.destination = Bit6Address(kind:.USERNAME, 
    	                             value:"user2")
    message.sendWithCompletionHandler ({ (response, error) -> Void in
        if (error == nil) {
            NSLog("Message Sent");
        }
        else {
            NSLog("Message Failed with Error: %@",error.localizedDescription);
        }
    }
    
    // The rest of your imagePickerController:didFinishPickingMediaWithInfo: method
})
```
