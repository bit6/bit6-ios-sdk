---
category: multimedia messaging
title: 'Attachment Actions'
layout: nil
---

Let the user view the attachment preview, play audio files, view location on the map, view the picture fullscreen etc.

###Get the Status for a Message Attachment

Check the attachment state for a given messages. <br><br>
Contants to be used:<br>
`Bit6MessageAttachmentCategory_THUMBNAIL` - for thumbnails
`Bit6MessageAttachmentCategory_FULL_SIZE` - for full size 

```objc
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
            //the file is not in cache, but it being downloaded
            break;
        case Bit6MessageAttachmentStatus_FOUND:
            //the file is in cache, ready to be used
            break;
    }
```



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

<img style="max-width:100%" src="images/thumb_img_view.png"/>

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
        //Open in AppleMaps
        [Bit6 openLocationOnMapsFromMessage:msg];
        /*
        //Open in GoogleMaps app, if available
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL 
                                            URLWithString:@"comgooglemaps://"]]) {
            NSString *urlStr = [NSString 
                               stringWithFormat:@"comgooglemaps://?center=%@,%@&zoom=14",
                                     msg.data.lat.description, msg.data.lng.description];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        */

        /*
        //Open in Waze app, if available
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL 
                                            URLWithString:@"waze://"]]) {
            NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%@,%@&navigate=yes", 
                                       msg.data.lat.description, msg.data.lng.description];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        */
    }
    else if (msg.type == Bit6MessageType_Attachments) {
        //play an audio file
        if (msg.attachFileType == Bit6MessageFileType_AudioMP4) {
            [[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:msg 
                                                        errorHandler:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil 
                                           delegate:nil cancelButtonTitle:@"OK" 
                                                        otherButtonTitles:nil] show];
            }];
        }
        else if (msg.attachFileType == Bit6MessageFileType_VideoMP4) {
            [Bit6 playVideoFromMessage:msg viewController:self.navigationController];
        }
        else if (msg.attachFileType == Bit6MessageFileType_ImageJPG || 
                 msg.attachFileType == Bit6MessageFileType_ImagePNG) {
        //code to navigate to another screen to show the image in full size
        }
    }
}
```

__Step 3.__ Set the `Bit6ThumbnailImageView` delegate

```objc
Bit6ThumbnailImageView *imageView = ...
imageView.thumbnailImageViewDelegate = self;
```

###Load an image attachment

__Step 1.__ Check if a message has an image to show:

```objc
Bit6Message *message = ...
if (message.type == Bit6MessageType_Attachments && 
                            (msg.attachFileType == Bit6MessageFileType_ImageJPG || 
                             msg.attachFileType == Bit6MessageFileType_ImagePNG)) {
//can show full image
}
```
__Step 2.__ Use a `Bit6ImageView` object to show the image.

Add <b>`Bit6ImageView`</b> to nib/storyboard: add an `UIImageView` object and change its class to `Bit6ImageView`.

---

<img style="max-width:100%" src="images/bit6ImageView.png"/>

---


__Step 3.__ Set the message to be used with the <b>`Bit6ImageView`</b> object:

```objc
Bit6Message *message = ...
Bit6ImageView *imageView = ...
imageView.message = message;
```