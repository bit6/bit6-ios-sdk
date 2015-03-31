---
category: multimedia messaging
title: 'Attachment Actions'
---

Let the user view the attachment preview, play audio files, view location on the map, view the picture fullscreen etc.

###Get the Path for a Message Attachment

Check the attachment path for a given message. <br><br>
Contants to be used:<br>
`Bit6MessageAttachmentCategory_THUMBNAIL` - for thumbnails
`Bit6MessageAttachmentCategory_FULL_SIZE` - for full size 

```objc
//ObjectiveC
Bit6Message *msg = ...;
NSString *thumbnailAttachmentPath = [msg attachmentPathForAttachmentCategory:
									Bit6MessageAttachmentCategory_THUMBNAIL];
NSString *fullAttachmentPath = [msg attachmentPathForAttachmentCategory:
									Bit6MessageAttachmentCategory_FULL_SIZE];
```
```swift
//Swift
var msg : Bit6Message = ...
var thumbnailAttachmentPath = msg.attachmentStatusForAttachmentCategory(
						.THUMBNAIL)
var fullAttachStatus = msg.attachmentStatusForAttachmentCategory(
						.FULL_SIZE)
```


###Get the Status for a Message Attachment

Check the attachment state for a given message. <br><br>
Contants to be used:<br>
`Bit6MessageAttachmentCategory_THUMBNAIL` - for thumbnails
`Bit6MessageAttachmentCategory_FULL_SIZE` - for full size 

```objc
//ObjectiveC
Bit6Message *msg = ...;
    switch ([msg attachmentStatusForAttachmentCategory:
                 Bit6MessageAttachmentCategory_FULL_SIZE]) {
        case Bit6MessageAttachmentStatus_INVALID:
            //the message can't have an attachment, for example a text message
            break;
        case Bit6MessageAttachmentStatus_FAILED:
            //the attachment can't be downloaded, for example because of an 
            //error when uploading the attachment
            break;
        case Bit6MessageAttachmentStatus_NOT_FOUND:
            //the file is not in cache
            break;
        case Bit6MessageAttachmentStatus_DOWNLOADING:
            //the file is not in cache, but is being downloaded
            break;
        case Bit6MessageAttachmentStatus_FOUND:
            //the file is in cache, ready to be used
            break;
    }
```
```swift
//Swift
var msg : Bit6Message = ...
	switch (msg.attachmentStatusForAttachmentCategory(
            .FULL_SIZE)) {
        case .INVALID:
            //the message can't have an attachment, for example a text message
            break;
        case .FAILED:
            //the attachment can't be downloaded, for example because of an
            //error when uploading the attachment
            break;
        case .NOT_FOUND:
            //the file is not in cache
            break;
        case .DOWNLOADING:
            //the file is not in cache, but is being downloaded
            break;
        case .FOUND:
            //the file is in cache, ready to be used
            break;
        }
```



###Preview the attachment

__Step 1.__ Check if the message has a preview to show:

```objc
//ObjectiveC
Bit6Message *message = ...
if (message.type != Bit6MessageType_Text) {
//can show preview
}
```
```swift
//Swift
var msg : Bit6Message = ...
if (message.type != .Text) {
//can show preview
}
```
__Step 2.__ To show the preview, use a `Bit6ThumbnailImageView` object. To add `Bit6ThumbnailImageView` to your nib/storyboard just add an `UIImageView` object and change its class to `Bit6ThumbnailImageView`:

<img class="shot" src="images/thumb_img_view.png"/>

__Step 3.__ Set the message to be used with the `Bit6ThumbnailImageView` object:

```objc
//ObjectiveC
Bit6Message *message = ...
Bit6ThumbnailImageView *imageView = ...
imageView.message = message;
```
```swift
//Swift
var msg : Bit6Message = ...
var imageView : Bit6ThumbnailImageView = ...
imageView.message = message
```


###Interact with the attachment

__Step 1.__ Implement the `Bit6ThumbnailImageViewDelegate`

```objc
//ObjectiveC
@interface ChatsViewController <Bit6ThumbnailImageViewDelegate>
```
```swift
//Swift
class ChatsViewController : Bit6ThumbnailImageViewDelegate
```

__Step 2.__ Depending on the attachment type, show the location on the map, play the audio or video, open the picture full screen:

```objc
//ObjectiveC
- (void) touchedThumbnailImageView:(Bit6ThumbnailImageView*)thumbnailImageView
{
    Bit6Message *msg = thumbnailImageView.message;
    if (msg.type == Bit6MessageType_Location) {
        //Open in AppleMaps
        [Bit6 openLocationOnMapsFromMessage:msg];
    }
    else if (msg.type == Bit6MessageType_Attachments) {
        //play an audio file
        if (msg.attachFileType == Bit6MessageFileType_AudioMP4) {
            [[Bit6 audioPlayer] startPlayingAudioFileInMessage:msg errorHandler:^(NSError *error) {
                //an error occurred
            }];
        }
        else if (msg.attachFileType == Bit6MessageFileType_VideoMP4) {
            if ([Bit6 shouldDownloadVideoBeforePlaying]) {
                if (fullAttachStatus==Bit6MessageAttachmentStatus_FOUND) {
                    [Bit6 playVideoFromMessage:msg viewController:self.navigationController];
                }
            }
            else {
                [Bit6 playVideoFromMessage:msg viewController:self.navigationController];
            }
        }
        else if (msg.attachFileType == Bit6MessageFileType_ImageJPG || 
                 msg.attachFileType == Bit6MessageFileType_ImagePNG) {
        //code to navigate to another screen to show the image in full size
        }
    }
}
```
```swift
//Swift
func touchedThumbnailImageView(thumbnailImageView:Bit6ThumbnailImageView) {
        var msg = thumbnailImageView.message
        
        var fullAttachStatus = msg.attachmentStatusForAttachmentCategory(.FULL_SIZE)
        
        if (msg.type == .Location){
            //Open in AppleMaps
            Bit6.openLocationOnMapsFromMessage(msg)
        }
            
        else if (msg.type == .Attachments) {
        	//play an audio file
            if (msg.attachFileType == .AudioMP4) {
                Bit6.audioPlayer().startPlayingAudioFileInMessage(msg,errorHandler: { (error) -> Void in
                        //an error occurred
                })
            }
            else if (msg.attachFileType == .VideoMP4) {
                if (Bit6.shouldDownloadVideoBeforePlaying()) {
                    if (fullAttachStatus == .FOUND) {
                        Bit6.playVideoFromMessage(msg, viewController:self.navigationController);
                    }
                }
                else {
                    Bit6.playVideoFromMessage(msg, viewController:self.navigationController);
                }
            }
            else if (msg.attachFileType == .ImageJPG || msg.attachFileType == .ImagePNG) {
                //code to navigate to another screen to show the image in full size
            }
        }
    }
```


__Step 3.__ Set the `Bit6ThumbnailImageView` delegate

```objc
//ObjectiveC
Bit6ThumbnailImageView *imageView = ...
imageView.thumbnailImageViewDelegate = self;
```
```swift
//Swift
var imageView : Bit6ThumbnailImageView  = ...
imageView.thumbnailImageViewDelegate = self
```

###Load an image attachment

__Step 1.__ Check if a message has an image to show:

```objc
//ObjectiveC
Bit6Message *msg = ...
if (msg.type == Bit6MessageType_Attachments && 
                            (msg.attachFileType == Bit6MessageFileType_ImageJPG || 
                             msg.attachFileType == Bit6MessageFileType_ImagePNG)) {
//can show full image
}
```
```swift
//Swift
var msg : Bit6Message = ...
if (msg.type == .Attachments && 
                            (msg.attachFileType == .ImageJPG || 
                             msg.attachFileType == .ImagePNG)) {
//can show full image
}
```
__Step 2.__ Use a `Bit6ImageView` object to show the image.

Add `Bit6ImageView` to nib/storyboard: add an `UIImageView` object and change its class to `Bit6ImageView`.

<img class="shot" src="images/full_image_view.png"/>

__Step 3.__ Set the message to be used with the `Bit6ImageView` object:

```objc
//ObjectiveC
Bit6Message *message = ...
Bit6ImageView *imageView = ...
imageView.message = message;
```
```swift
//Swift
var msg : Bit6Message = ...
var imageView : Bit6ImageView = ...
imageView.message = message
```

###Download Video Attachments

By default when interacting with a video attachment the file will be streamed. If you want to change this behaviour by forcing the video file to download you can add the following in your `AppDelegate`

```objc
//ObjectiveC
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6 setShouldDownloadVideoBeforePlaying:YES];
        
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```
```swift
//Swift
func application(application: UIApplication, 
		didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // start of your application:didFinishLaunchingWithOptions: method
        // ...
        
        Bit6.setShouldDownloadVideoBeforePlaying(true)
        
        // The rest of your application:didFinishLaunchingWithOptions: method
        // ...
    }
```