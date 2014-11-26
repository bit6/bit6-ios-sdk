---
category: calling
title: 'UI'
layout: nil
---

### InCall screen customization

When the call is in progress, customize the controls of the InCall screen

__Step 1.__ Set your application delegate as the delegate for `Bit6InCallController`

```objc
//ObjectiveC
@interface AppDelegate : Bit6ApplicationManager <Bit6InCallControllerDelegate>

- (BOOL)application:(UIApplication *)application 
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // First part of the application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6InCallController sharedInstance].delegate = self;
    
        // The rest of the application:didFinishLaunchingWithOptions: method
        // ...
    }
    
@end
```

```swift
//Swift
class AppDelegate: Bit6ApplicationManager, UIApplicationDelegate,
				   Bit6InCallControllerDelegate {
                   
    func application(application: UIApplication, 
    didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // First part of the application:didFinishLaunchingWithOptions: method
        // ...
        
        Bit6InCallController.sharedInstance().delegate = self;
        
        // The rest of the application:didFinishLaunchingWithOptions: method
        // ...
    }
    
}
```

__Step 2.__ Configure the UIView

```objc
//ObjectiveC
//make own control overlay with destination, call status and mute/camera/hangup buttons
- (UIView*) controlsOverlayViewForInCallController:(Bit6InCallController*)icc
{
	//your code to create the UIView
	...

    //set the destination username label
    displayNameLabel.text = icc.displayName;
    
    //add actions to the custom buttons
    [cameraButton addTarget:icc 
                     action:@selector(switchCamera) 
                     forControlEvents:UIControlEventTouchUpInside];
    [muteButton addTarget:icc
                   action:@selector(muteAudio) 
                   forControlEvents:UIControlEventTouchUpInside];
    [hangupButton addTarget:icc
                     action:@selector(hangup) 
                     forControlEvents:UIControlEventTouchUpInside];
    [speakerButton addTarget:icc
                     action:@selector(switchSpeaker)
                     forControlEvents:UIControlEventTouchUpInside];
    
    //if this is an video call, hide the speaker controls
    if (icc.isVideoCall) {
        speakerButton.hidden = YES;
        speakerLabel.hidden = YES;
    }
    //if this is an audio call, hide the camera controls
    else {
        cameraButton.hidden = YES;
        cameraLabel.hidden = YES;
    }

    return overlayView;
}
```
```swift
//Swift
//make own control overlay with destination, call status and mute/camera/hangup buttons
func controlsOverlayViewForInCallController(icc:Bit6InCallController) -> UIView! {
{
	//your code to create the UIView
	...

    //set the destination username label
    displayNameLabel.text = icc.displayName
    
    //add actions to the custom buttons
    cameraButton.addTarget(icc, 
                    action: "switchCamera", 
                    forControlEvents: UIControlEvents.TouchUpInside)
    muteButton.addTarget(icc, 
                  action: "muteAudio", 
                  forControlEvents: UIControlEvents.TouchUpInside)
    hangupButton.addTarget(icc, 
                   action: "hangup", 
                   forControlEvents: UIControlEvents.TouchUpInside)
    speakerButton.addTarget(icc, 
                     action: "switchSpeaker", 
                     forControlEvents: UIControlEvents.TouchUpInside)
    
    //if this is an video call, hide the speaker controls
    if (icc.videoCall) {
        speakerButton.hidden = true;
        speakerLabel.hidden = true;
    }
    //if this is an audio call, hide the camera controls
    else {
        cameraButton.hidden = true;
        cameraLabel.hidden = true;
    }

    return overlayView;
}
```

__Step 3.__ Refresh the UIView

```objc
//ObjectiveC

//refresh the controls overlay
- (void) refreshControlsOverlayView:(UIView*)view 
                   inCallController:(Bit6InCallController*)icc
{
    UILabel *muteLabel = (UILabel*) [view viewWithTag:6];
    muteLabel.text = icc.isAudioMuted?@"Unmute":@"Mute";
    
    UILabel *speakerLabel = (UILabel*) [view viewWithTag:10];
    if (icc.isSpeakerEnabled) {
        speakerLabel.text = @"Disable Speaker";
    }
    else {
        speakerLabel.text = @"Enable Speaker";
    }
}

//called each second to allow the refresh of a timer label
- (void) refreshTimerInOverlayView:(UIView*)view 
                  inCallController:(Bit6InCallController*)icc
{
    UILabel *statusLabel = (UILabel*) [view viewWithTag:2];
    if (!icc.isConnected) {
        statusLabel.text = @"Connecting...";
    }
    else {
        int seconds = icc.seconds;
        int minutes = seconds/60;
        statusLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds-minutes*60];
    }
}
```

```swift
//Swift

//refresh the controls overlay
func refreshControlsOverlayView(view:UIView, 
                inCallController icc:Bit6InCallController) -> Void {
{
    var muteLabel = view.viewWithTag(6) as UILabel
    muteLabel.text = icc.audioMuted ?"Unmute":"Mute"
    
    var speakerLabel = view.viewWithTag(10) as UILabel
    if (icc.speakerEnabled) {
        speakerLabel.text = "Disable Speaker"
    }
    else {
        speakerLabel.text = "Enable Speaker"
    }
}

//called each second to allow the refresh of a timer label
func refreshTimerInOverlayView(view:UIView, 
               inCallController icc:Bit6InCallController) -> Void {
{
    var statusLabel = view.viewWithTag(2) as UILabel
    if (!icc.connected) {
        statusLabel.text = "Connecting..."
    }
    else {
        var seconds = icc.seconds
        var minutes = seconds/60
        statusLabel.text = String(format:"%02d:%02d",minutes,seconds-minutes*60)
    }
}
```