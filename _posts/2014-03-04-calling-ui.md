---
category: calling
title: 'In-Call UI'
---

See the Bit6CallDemo and Bit6CallDemo-Swift sample projects included with the sdk.

__Step 1.__ Create an UIViewController class that extends from Bit6CallViewController. All the implemented methods are optional.

```objc
//ObjectiveC
@interface MyCallViewController : Bit6CallViewController

@end

@implementation MyCallViewController

- (Bit6CallController*) callController
{
    return [[Bit6 callControllers] firstObject];
}

//called in the Main Thread when the UI controls should be updated. For example when the speaker is activated or the audio is muted.
- (void) refreshControlsView
{
	NSLog(@"Audio Muted: %@",[Bit6CallController audioMuted]?@"YES":@"NO");
    NSLog(@"Speaker Enabled: %@",[Bit6CallController speakerEnabled]?@"YES":@"NO");
}

//called in the Main Thread when the status of the call changes.
- (void) callStateChangedNotificationForCallController:(Bit6CallController*)callController
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
	[self secondsChangedNotificationForCallController:callController];
}

//called in the Main Thread each second to allow the refresh of a timer UILabel.
- (void) secondsChangedNotificationForCallController:(Bit6CallController*)callController
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
- (void)updateLayoutForVideoFeedViews:(NSArray*)videoFeedViews
{
	//Here you can do your own calculations to set the frames or just call super. You can easily keep the aspect ratio by using AVMakeRectWithAspectRatioInsideRect() (import AVFoundation/AVFoundation.h) to do an scaleToFit or Bit6MakeRectWithAspectRatioToFillRect to do an scaleToFill.
	[super updateLayoutForVideoFeedViews:videoFeedViews];
}

@end
```
```swift
//Swift
class MyCallViewController: Bit6CallViewController

var callController : Bit6CallController {
   get {
       return Bit6.callControllers().first as! Bit6CallController
   }
}

//called in the Main Thread when the UI controls should be updated. For example when the speaker is activated or the audio is muted.
override func refreshControlsView()
{
	if (Bit6CallController.audioMuted()){
       NSLog("Audio Muted: true")
   }
   else {
       NSLog("Audio Muted: false")
   }
   
   if (Bit6CallController.speakerEnabled()){
       NSLog("Speaker Enabled: true")
   }
   else {
       NSLog("Speaker Enabled: false")
   }
}

//called in the Main Thread when the status of the call changes.
override func callStateChangedNotificationForCallController(callController: Bit6CallController!)
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
	self.secondsChangedNotificationForCallController(callController)
}

//called in the Main Thread each second to allow the refresh of a timer UILabel.
override func secondsChangedNotificationForCallController(callController: Bit6CallController!) 
{
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
override func updateLayoutForVideoFeedViews(videoFeedViews: [AnyObject]!)
{
	//Here you can do your own calculations to set the frames or just call super. You can easily keep the aspect ratio by using AVMakeRectWithAspectRatioInsideRect() (import AVFoundation/AVFoundation.h) to do an scaleToFit or Bit6MakeRectWithAspectRatioToFillRect to do an scaleToFill.
	super.updateLayoutForVideoFeedViews(videoFeedViews)
}

@end
```

__Step 2.__ Implement the actions and do the connections in your nib/storyboard file.

```objc
//ObjectiveC
- (IBAction) switchCamera:(id)sender {
    [Bit6CallController switchCamera];
}

- (IBAction) muteCall:(id)sender {
    [Bit6CallController switchMuteAudio];
}

- (IBAction) hangup:(id)sender {
    [Bit6CallController hangupAll];
}

- (IBAction) speaker:(id)sender {
    [Bit6CallController switchSpeaker];
}
```
```swift
//Swift
@IBAction func switchCamera(sender : UIButton) {
   Bit6CallController.switchCamera()
}
    
@IBAction func muteCall(sender : UIButton) {
   Bit6CallController.switchMuteAudio()
}
    
@IBAction func hangup(sender : UIButton) {
   Bit6CallController.hangupAll()
}
    
@IBAction func speaker(sender : UIButton) {
   Bit6CallController.switchSpeaker()
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