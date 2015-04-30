---
category: calling
title: 'Peer to Peer Transfers'
---

See the DataChannelDemo sample project included with the sdk.

The process works similar to a regular audio/video call.

__Step1.__ Start the call.

```objc
//ObjectiveC
Bit6Address * address = ...
self.callController = [Bit6 startCallToAddress:address hasAudio:NO hasVideo:NO hasData:YES];

if (self.callController){
	//we listen to call state changes
	[callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
	
	//start the call
    [self.callController connectToViewController:nil];
}
else {
    //cannot make call to specified address
}
```
```swift
//Swift
var address : Bit6Address = ...
self.callController = Bit6.startCallToAddress(address, hasAudio:false, hasVideo:false, hasData:true)

if (self.callController != nil){
	//we listen to call state changes
	self.callController.addObserver(self, forKeyPath:"callState", options: .Old, context:nil)
	
	//start the call
    self.callController.connectToViewController(nil)
}
else {
    //cannot make call to specified address
}
```

__Note.__ See it's not required to set a `Bit6CallViewController` in the `connectToViewController()` call.

__Step2.__ Start a transfer.

```objc
//ObjectiveC
UIImage *image = ...
NSData *imageData = UIImagePNGRepresentation(image);
Bit6Transfer *transfer = [[Bit6Transfer alloc] initOutgoingTransferWithData:imageData name:@"my_image.png" mimeType:@"image/png"];
[self.callController startTransfer:transfer];

```
```swift
//Swift
//Soon
```

__Step3.__ Listen for incoming transfers and updates in outgoing transfers.

You need to handle the `Bit6TransferUpdateNotification`.

```objc
//ObjectiveC

[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(transferUpdateNotification:)
                                             name:Bit6TransferUpdateNotification
                                           object:self.callController];

- (void) transferUpdateNotification:(NSNotification*)notification
{
    Bit6Transfer *transfer = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    Bit6CallController *callController = notification.object;
    Bit6TransferType transferType = transfer.type;
    
    if (callController == self.callController) {
        //the transfer started
        if ([change isEqualToString:Bit6TransferStartedKey]) { }
        //transfer updated
        else if ([change isEqualToString:Bit6TransferProgressKey]) {
            CGFloat progressAtTheMoment = [notification.userInfo[Bit6ProgressKey] floatValue]; 
        }
        //the transfer ended
        else if ([change isEqualToString:Bit6TransferEndedKey]) {
        	//transfer received
            if (transferType == Bit6TransferType_INCOMING) {
                NSData *data = transfer.data;
                if ([object.mimeType hasPrefix:@"image/"]) {
                	UIImage *image = [UIImage imageWithData:data];
                }
            }
            else {
                //transfer sent
            }
        }
        //the transfer failed
        else if ([change isEqualToString:Bit6TransferEndedWithErrorKey]) {
            NSLog(@"%@",transfer.error.localizedDescription);
        }
    }
}


```
```swift
//Swift
//Soon
```