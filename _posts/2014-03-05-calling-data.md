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
Bit6CallController *callController = [Bit6 createCallTo:address streams:Bit6CallStreams_Data];

if (callController){
	self.callController = callController;

	//we listen to call state changes
	[callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
	
	//start the call
    [callController start];
}
else {
    //cannot make call to specified address
}
```
```swift
//Swift
let address : Bit6Address = ...
let callController = Bit6.createCallTo(address, streams:.Data)

if callController != nil {
	self.callController = callController

	//we listen to call state changes
	callController.addObserver(self, forKeyPath:"callState", options: .Old, context:nil)
	
	//start the call
    callController.start()
}
else {
    //cannot make call to specified address
}
```

__Note.__ See it's not required to create a `Bit6CallViewController` to make calls.

__Step2.__ Start a transfer.

```objc
//ObjectiveC
UIImage *image = ...
NSData *imageData = UIImagePNGRepresentation(image);
Bit6OutgoingTransfer *transfer = [[Bit6OutgoingTransfer alloc] initWithData:imageData name:@"my_image.png" mimeType:@"image/png"];
[self.callController startTransfer:transfer];

```
```swift
//Swift
let image = ...
let data = UIImagePNGRepresentation(image)
let transfer = Bit6OutgoingTransfer(data:imageData, name:"my_image.png", mimeType:"image/png")
self.callController.startTransfer(transfer)
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
        if ([change isEqualToString:Bit6TransferStartedKey]) { 
        	
        }
        //transfer updated
        else if ([change isEqualToString:Bit6TransferProgressKey]) {
            CGFloat progressAtTheMoment = [notification.userInfo[Bit6ProgressKey] floatValue]; 
        }
        //the transfer ended
        else if ([change isEqualToString:Bit6TransferEndedKey]) {
        	//transfer received
            if (transferType == Bit6TransferType_INCOMING) {
                if ([transfer.mimeType hasPrefix:@"image/"]) {
                	UIImage *image = [UIImage imageWithData:transfer.data];
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

NSNotificationCenter.defaultCenter().addObserver(self
                                        selector:"transferUpdateNotification:",
                                             name:Bit6TransferUpdateNotification,
                                           object:self.callController)

func transferUpdateNotification(notification:NSNotification)
{
    let transfer = notification.userInfo![Bit6ObjectKey] as! Bit6Transfer
    let change = notification.userInfo![Bit6ChangeKey] as! String
    let callController = notification.object as! Bit6CallController
    let transferType = transfer.type
    
    if callController == self.callController {
        switch change {
	        //the transfer started
	        case Bit6TransferStartedKey : break
	        
	        //transfer updated
            case Bit6TransferProgressKey :
                let progressAtTheMoment = (notification.userInfo![Bit6ProgressKey] as! NSNumber).floatValue
                
	        //the transfer ended
	        case Bit6TransferEndedKey :
	        	//transfer received
	            if transferType == .INCOMING {
	                if transfer.mimeType.hasPrefix("image/") {
	                	let image = UIImage(data:transfer.data)!
	                }
	            }
	            else {
	                //transfer sent
	            }
	        
	        //the transfer failed
	        case Bit6TransferEndedWithErrorKey :
	            NSLog("\(transfer.error.localizedDescription)")
	            
	        default: break
        }
    }
}

```