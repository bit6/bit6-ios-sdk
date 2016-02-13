---
category: multimedia messaging
title: 'Download Attachments'
---

### Download Attachments

`Bit6ThumbnailImageView` and `Bit6ImageView` classes can downloads the attachments automatically.

You can also download the files manually using the `Bit6FileDownloader` class. For example to download the thumbnail for a message:

```objc
//ObjectiveC
NSURL *url = message.remoteURLForThumbnailAttachment;
NSString *filePath = message.pathForThumbnailAttachment;
NSData* (^preparationBlock)(NSData *data) = ^(NSData *imageData) {
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *finalImage = ...
    return UIImagePNGRepresentation(finalImage);
};

[Bit6FileDownloader downloadFileAtURL:url 
						   toFilePath:filePath 
					 preparationBlock:preparationBlock 
					         priority:NSOperationQueuePriorityNormal 
					completionHandler:^(NSURL* location, NSURLResponse* response, NSError* error) {
                    	//operation completed
                    }
];

```

```swift
//Swift
let url = message.remoteURLForThumbnailAttachment!
let filePath = message.pathForThumbnailAttachment!
let preparationBlock = ({ (data:NSData) -> NSData in
    let image = UIImage(data:data)
    let finalImage = ...
    return UIImagePNGRepresentation(finalImage)!
})
        
Bit6FileDownloader.downloadFileAtURL(url, 
						  toFilePath:filePath, 
			   		preparationBlock:preparationBlock, 
			   				priority:.Normal) { (location, response, error) in
			   					//operation completed
			   				}
         
```

#####Note. The `preparationBlock` can be used to make changes to the downloaded data before saving it locally. For example you could download the thumbnail and apply a filter using this block.
