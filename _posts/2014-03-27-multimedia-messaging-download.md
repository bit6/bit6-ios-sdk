---
category: multimedia messaging
title: 'Download Attachments'
---

### Download Attachments

`Bit6ThumbnailImageView` and `Bit6ImageView` classes handle attachment downloading and rendering.

You can also download the files manually by using `[Bit6Message downloadAttachment:]` and listen to `Bit6FileDownloadedNotification`.

```objc
//ObjectiveC

//listen to download_files notification
[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(fileDownloadedNotification:) 
                                             name:Bit6FileDownloadedNotification
                                           object:message];

Bit6Message *message = ...
//download the thumbnail
[message downloadAttachment:Bit6MessageAttachmentCategory_THUMBNAIL];
//download the full attachment
[message downloadAttachment:Bit6MessageAttachmentCategory_FULL_SIZE];

- (void) fileDownloadedNotification:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
		//Can be Bit6MessageAttachmentCategory_THUMBNAIL or Bit6MessageAttachmentCategory_FULL_SIZE
		Bit6MessageAttachmentCategory category = [notification.userInfo[@"attachmentCategory"] intValue];

        switch (category) {
            case Bit6MessageAttachmentStatus_INVALID: // the message doesn't have the specified attachment
            case Bit6MessageAttachmentStatus_FAILED: // failed to download the attachment
            case Bit6MessageAttachmentStatus_NOT_FOUND: // attachment is not downloading
            case Bit6MessageAttachmentStatus_DOWNLOADING: // attachment is downloading
            case Bit6MessageAttachmentStatus_FOUND: //attachment is in cache
        }
    });
}

```
```swift
//Swift

//listen to download_files notification
NSNotificationCenter.defaultCenter().addObserver(self, 
										selector: "fileDownloadedNotification:", 
											name: Bit6FileDownloadedNotification, 
										  object: message)

var message : Bit6Message = ...
//download the thumbnail
message.downloadAttachment(.THUMBNAIL)
//download the full attachment
message.downloadAttachment(.FULL_SIZE)

func fileDownloadedNotification(notification:NSNotification){

dispatch_async(dispatch_get_main_queue()) {
	//Can be Bit6MessageAttachmentCategory.THUMBNAIL or Bit6MessageAttachmentCategory.FULL_SIZE
	var category : Bit6MessageAttachmentCategory = notification.userInfo["attachmentCategory"].intValue()

    switch category {
        case .INVALID: // the message doesn't have the specified attachment
        case .FAILED: // failed to download the attachment
        case .NOT_FOUND: // attachment is not downloading
        case .DOWNLOADING: // attachment is downloading
        case .FOUND: //attachment is in cache
    }
  }
}
```
