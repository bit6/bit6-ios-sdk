---
category: calling
title: 'UI'
layout: nil
---

### InCall screen customization

When the call is in progress, customze the controls of the InCall screen

__Step 1.__ Set AppDelegate as the delegate for `Bit6InCallController`

```objc
- (BOOL)application:(UIApplication *)application 
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // First part of the application:didFinishLaunchingWithOptions: method
        // ...
        
        [Bit6InCallController sharedInstance].delegate = self;
    
        // The rest of the application:didFinishLaunchingWithOptions: method
        // ...
    }
```

__Step 2.__ Configure the UIView

```objc
//make own control overlay with destination, call status and mute/camera/hangup buttons
- (UIView*) controlsOverlayViewForInCallController:(Bit6InCallController*)icc
{
	//your code to create the UIView
	...

    //set the destination username label
    displayNameLabel.text = [Bit6InCallController sharedInstance].displayName;
    
    //add actions to the custom buttons
    [cameraButton addTarget:[Bit6InCallController sharedInstance] 
                     action:@selector(switchCamera) 
                     forControlEvents:UIControlEventTouchUpInside];
    [muteButton addTarget:[Bit6InCallController sharedInstance] 
                   action:@selector(muteAudio) 
                   forControlEvents:UIControlEventTouchUpInside];
    [hangupButton addTarget:[Bit6InCallController sharedInstance] 
                     action:@selector(hangup) 
                     forControlEvents:UIControlEventTouchUpInside];
    
    //if this is an audio call, hide the camera controls
    if (![Bit6InCallController sharedInstance].isVideoCall) {
        cameraButton.hidden = YES;
        cameraLabel.hidden = YES;
    }
    return overlayView;
}
```

__Step 3.__ Refresh the UIView

```objc
//refresh the controls overlay
- (void) refreshControlsOverlayView:(UIView*)view inCallController:(Bit6InCallController*)icc
{
    UILabel *statusLabel = (UILabel*) [view viewWithTag:...];
    statusLabel.text = 
         [Bit6InCallController sharedInstance].isConnected?@"Connected":@"Connecting...";
    
    UILabel *muteLabel = (UILabel*) [view viewWithTag:...];
    muteLabel.text = icc.isAudioMuted?@"Mute":@"Unmute";
}
```