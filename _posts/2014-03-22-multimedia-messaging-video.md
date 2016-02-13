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
    message.destination = [Bit6Address addressWithUsername:@"user2"];
    
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
    
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            //Message Sent
        }
        else {
            //Message Failed
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
    message.destination = Bit6Address(username:"user2")
    
    let mediaType = info[UIImagePickerControllerMediaType] as! String
    if mediaType == (kUTTypeMovie as String) {
    	//here we add the video to the message
        message.videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
        
        //if we used the camera to take the video we have to set the cropping times 
        message.videoCropStart = 
               info["_UIImagePickerControllerVideoEditingStart"] as! NSNumber
        message.videoCropEnd = 
               info["_UIImagePickerControllerVideoEditingEnd"] as! NSNumber
    }
    
    message.sendWithCompletionHandler { (response, error) in
        if error == nil {
            //Message Sent
        }
        else {
            //Message Failed
        }
    }
    
    // The rest of your imagePickerController:didFinishPickingMediaWithInfo: method
}
```
