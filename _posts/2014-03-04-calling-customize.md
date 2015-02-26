---
category: calling
title: 'Customize the In-Call Screen'
---

See the Bit6CallDemo and Bit6CallDemo-Swift sample projects included with the sdk.

__Step 1.__ Create an UIViewController class that extends from Bit6CallViewController. All the implemented methods are optional.

```objc
//ObjectiveC
@interface MyCallViewController : Bit6CallViewController

@end

@implementation MyCallViewController

//called in the Main Thread when the UI controls should be updated. For example when the speaker is activated or the audio is muted.
- (void) refreshControlsView
{
	NSLog(@"Audio Muted: %@",self.callController.audioMuted?@"YES":@"NO");
    NSLog(@"Speaker Enabled: %@",self.callController.speakerEnabled?@"YES":@"NO");
}

//called in the Main Thread when the status of the call changes.
- (void) callStateChangedNotification
{
	switch (self.callController.callState) {
        case Bit6CallState_NEW: NSLog(@"Call created"); break;
        case Bit6CallState_PROGRESS: NSLog(@"Call is being started"); break;
        case Bit6CallState_ANSWER: NSLog(@"Call was answered"); break;
        case Bit6CallState_END: NSLog(@"Call ends"); break;
        case Bit6CallState_ERROR: NSLog(@"Call ends with an error"); break;
        case Bit6CallState_DISCONNECTED: NSLog(@"Call is disconnected for the moment. Will try to reconnect again."); break;
    }

	//refresh the timer label
	[self secondsChangedNotification];
}

//called in the Main Thread each second to allow the refresh of a timer UILabel.
- (void) secondsChangedNotification
{
	switch (self.callController.callState) {
        case Bit6CallState_NEW: case Bit6CallState_PROGRESS:
            NSLog(@"Connecting..."); break;
        case Bit6CallState_ANSWER:
            NSLog(@"Seconds: %@",[Bit6Utils clockFormatForSeconds:self.callController.seconds]); break;
        case Bit6CallState_END: case Bit6CallState_MISSED: case Bit6CallState_ERROR: case Bit6CallState_DISCONNECTED:
            NSLog(@"Disconnected"); break;
    }
}

//called in the Main Thread to customize the frames for the video feeds. You can call [self setNeedsUpdateVideoViewLayout] at any time to force a refresh of the frames.
- (void) updateLayoutForRemoteVideoView:(UIView*)remoteVideoView 
 						localVideoView:(UIView*)localVideoView 
 				remoteVideoAspectRatio:(CGSize)remoteVideoAspectRatio
 				 localVideoAspectRatio:(CGSize)localVideoAspectRatio
{
	//Here you can do your own calculations to set the frames or just call super. You can easily keep the aspect ratio by using AVMakeRectWithAspectRatioInsideRect() (import AVFoundation/AVFoundation.h) to do an scaleToFit or Bit6MakeRectWithAspectRatioToFillRect to do an scaleToFill.

	CGFloat padding = 20.0f;
    CGRect localVideoFrame = AVMakeRectWithAspectRatioInsideRect(localVideoAspectRatio, self.view.bounds);
    localVideoFrame.size.width = localVideoFrame.size.width / 3;
    localVideoFrame.size.height = localVideoFrame.size.height / 3;
    localVideoFrame.origin.x = CGRectGetMaxX(self.view.bounds) - localVideoFrame.size.width - padding;
    localVideoFrame.origin.y = CGRectGetMaxY(self.view.bounds) - localVideoFrame.size.height -  padding;
    
    CGRect remoteVideoFrame = AVMakeRectWithAspectRatioInsideRect(remoteVideoAspectRatio, self.view.bounds);
    
    remoteVideoView.frame = remoteVideoFrame;
    localVideoView.frame = localVideoFrame;
}

@end
```
```swift
//Swift
class MyCallViewController: Bit6CallViewController

//called in the Main Thread when the UI controls should be updated. For example when the speaker is activated or the audio is muted.
override func refreshControlsView()
{
	if (self.callController.audioMuted){
       NSLog("Audio Muted: true")
   }
   else {
       NSLog("Audio Muted: false")
   }
   
   if (self.callController.speakerEnabled){
       NSLog("Speaker Enabled: true")
   }
   else {
       NSLog("Speaker Enabled: false")
   }
}

//called in the Main Thread when the status of the call changes.
- (void) callStateChangedNotification
{
	switch (self.callController.callState) {
       case .NEW: NSLog("Call created");
       case .PROGRESS: NSLog("Call is being started");
       case .ANSWER: NSLog("Call was answered");
       case .END: NSLog("Call ends");
       case .MISSED: NSLog("Missed Call");
       case .ERROR: NSLog("Call ends with an error");
       case .DISCONNECTED: NSLog("Call is disconnected for the moment. Will try to reconnect again.");
    }

	//refresh the timer label
	self.secondsChangedNotification()
}

//called in the Main Thread each second to allow the refresh of a timer UILabel.
override func secondsChangedNotification() {
   switch (self.callController.callState) {
	   case .NEW: fallthrough case .PROGRESS:
	       self.timerLabel.text = "Connecting..."
	   case .ANSWER:
	       self.timerLabel.text = Bit6Utils.clockFormatForSeconds(Double(self.callController.seconds))
	   case .DISCONNECTED:fallthrough case .END:fallthrough case .MISSED:fallthrough case .ERROR:
	       self.timerLabel.text = "Disconnected"
   }
}

//called to customize the frames for the video feeds. You can call [self setNeedsUpdateVideoViewLayout] at any time to force a refresh of the frames.
override func updateLayoutForRemoteVideoView(remoteVideoView:UIView,
                                              localVideoView:UIView,
                                      remoteVideoAspectRatio:CGSize,
                                       localVideoAspectRatio:CGSize)
{
{
	//Here you can do your own calculations to set the frames or just call super. You can easily keep the aspect ratio by using AVMakeRectWithAspectRatioInsideRect() (import AVFoundation/AVFoundation.h) to do an scaleToFit or Bit6MakeRectWithAspectRatioToFillRect to do an scaleToFill.

	var padding = 20.0 as CGFloat
    var localVideoFrame = AVMakeRectWithAspectRatioInsideRect(localVideoAspectRatio, self.view.bounds)
    localVideoFrame.size.width = localVideoFrame.size.width / 3
    localVideoFrame.size.height = localVideoFrame.size.height / 3
    localVideoFrame.origin.x = CGRectGetMaxX(self.view.bounds) - localVideoFrame.size.width - padding
    localVideoFrame.origin.y = CGRectGetMaxY(self.view.bounds) - localVideoFrame.size.height -  padding
    localVideoView.frame = localVideoFrame
    
    var remoteVideoFrame = AVMakeRectWithAspectRatioInsideRect(remoteVideoAspectRatio, self.view.bounds)
    remoteVideoView.frame = remoteVideoFrame
}

@end
```

__Step 2.__ Implement the actions and do the connections in your nib/storyboard file.

```objc
//ObjectiveC
- (IBAction) switchCamera:(id)sender {
    [self.callController switchCamera];
}

- (IBAction) muteCall:(id)sender {
    [self.callController switchMuteAudio];
}

- (IBAction) hangup:(id)sender {
    [self.callController hangup];
}

- (IBAction) speaker:(id)sender {
    [self.callController switchSpeaker];
}
```
```swift
//Swift
@IBAction func switchCamera(sender : UIButton) {
   self.callController.switchCamera()
}
    
@IBAction func muteCall(sender : UIButton) {
   self.callController.switchMuteAudio()
}
    
@IBAction func hangup(sender : UIButton) {
   self.callController.hangup()
}
    
@IBAction func speaker(sender : UIButton) {
   self.callController.switchSpeaker()
}
```

__Step 3.__ Do some additional configurations on your viewDidLoad method

```objc
//ObjectiveC
- (void)viewDidLoad {
    NSLog(@"Other User Display Name %@", self.callController.otherDisplayName);
    
    if (! self.callController.hasVideo) {
		//hide switch camera option from the UI
    }

	//On iPad and iPod the audio always goes through the speaker.
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"]){
        //hide speaker option from the UI
    }
    
    [super viewDidLoad];
}
```
```swift
//Swift
override func viewDidLoad() {
   NSLog("Other User Display Name \(self.callController.otherDisplayName)")
   
   if (!self.callController.hasVideo) {
       //hide switch camera option from the UI
   }
   
   //On iPad and iPod the audio always goes through the speaker.
   var deviceType : NSString = UIDevice.currentDevice().model
   if (!deviceType.isEqualToString("iPhone") ) {
       //hide speaker option from the UI
   }
   
   super.viewDidLoad()
}
```

__Step 4.__ To use you custom class add it as a param in the `-[Bit6CallController connectToViewController:]` call.

```objc
//ObjectiveC
MyCallViewController *cvc = ....
[callController connectToViewController:cvc];
```
```swift
//Swift
var cvc : MyCallViewController = ...
callController.connectToViewController(cvc)
```