---
category: multimedia messaging
title: 'Attachment Actions'
layout: nil
---

Let the user view the attachment preview, play audio files, view location on the map, view the picture fullscreen etc.


###Preview the attachment

__Step 1.__ Check if the message has a preview to show:

```objc
Bit6Message *message = ...
if (message.type != Bit6MessageType_Text) {
//can show preview
}
```
__Step 2.__ To show the preview, use a `Bit6ThumbnailImageView` object. To add `Bit6ThumbnailImageView` to your nib/storyboard just add an `UIImageView` object and change its class to `Bit6ThumbnailImageView`:

---

<img style="width:100%" src="images/thumb-img-view.png"/>

---

__Step 3.__ Set the message to be used with the `Bit6ThumbnailImageView` object:

```objc
Bit6Message *message = ...
Bit6ThumbnailImageView *imageView = ...
imageView.message = message;
```

###Interact with the attachment

__Step 1.__ Implement the `Bit6ThumbnailImageViewDelegate`

```objc
@interface ChatsViewController <Bit6ThumbnailImageViewDelegate>
```

__Step 2.__ Depending on the attachment type, show the location on the map, play the audio or video, open the picture full screen:

```objc
- (void) touchedThumbnailImageView:(Bit6ThumbnailImageView*)thumbnailImageView
{
    Bit6Message *msg = thumbnailImageView.message;
    if (msg.type == Bit6MessageType_Location) {
        [msg openLocationOnMaps];
    }
    else if (msg.type == Bit6MessageType_Attachments) {
    	//we play an audio file
        if (msg.attachFileType == Bit6MessageFileType_AudioMP4) {
            [[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:msg];
        }
        //we play a video file
        else if (msg.attachFileType == Bit6MessageFileType_VideoMP4) {
            [msg playVideoOnViewController:self.navigationController];
        }
        else {
        //handle other cases like Bit6MessageFileType_ImagePNG and 
        //Bit6MessageFileType_ImageJPG
        }
    }
}
```

__Step 3.__ Set the the `Bit6ThumbnailImageView` delegate

```objc
Bit6ThumbnailImageView *imageView = ...
imageView.thumbnailImageViewDelegate = self;
```