//
//  AppDelegate.m
//  Test
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <Bit6InCallControllerDelegate>
{
    id _overlayViewNib;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    #warning Remember to set your api key
    [Bit6 startWithApiKey:@"your_api_key" pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT launchingWithOptions:launchOptions];
    
    //set this if you want customize the controls overlay in the inCall screen
//    [Bit6InCallController sharedInstance].delegate = self;
    
    return YES;
}

#pragma mark - Bit6InCallControllerDelegate

//here we make our own control overlay with destination, call status and mute/camera/hangup buttons
- (UIView*) controlsOverlayViewForInCallController:(Bit6InCallController*)icc
{
    NSArray *topLevelNibObjects = [[self overlayViewNib] instantiateWithOwner:self options:nil];
    UIView *overlayView = [topLevelNibObjects objectAtIndex:0];
    
    UILabel *displayNameLabel = (UILabel*) [overlayView viewWithTag:1];
    //        UILabel *statusLabel = (UILabel*) [overlayView viewWithTag:2];
    UIButton *cameraButton = (UIButton*) [overlayView viewWithTag:3];
    UILabel *cameraLabel = (UILabel*) [overlayView viewWithTag:4];
    UIButton *muteButton = (UIButton*) [overlayView viewWithTag:5];
    //        UILabel *muteLabel = (UILabel*) [overlayView viewWithTag:6];
    UIButton *hangupButton = (UIButton*) [overlayView viewWithTag:7];
    //        UILabel *hangupLabel = (UILabel*) [overlayView viewWithTag:8];
    UIButton *speakerButton = (UIButton*) [overlayView viewWithTag:9];
    UILabel *speakerLabel = (UILabel*) [overlayView viewWithTag:10];
    
    displayNameLabel.text = [Bit6InCallController sharedInstance].displayName;
    
    [cameraButton addTarget:[Bit6InCallController sharedInstance] action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [muteButton addTarget:[Bit6InCallController sharedInstance] action:@selector(muteAudio) forControlEvents:UIControlEventTouchUpInside];
    [hangupButton addTarget:[Bit6InCallController sharedInstance] action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
    [speakerButton addTarget:[Bit6InCallController sharedInstance] action:@selector(switchSpeaker) forControlEvents:UIControlEventTouchUpInside];
    
    if ([Bit6InCallController sharedInstance].isVideoCall) {
        speakerButton.hidden = YES;
        speakerLabel.hidden = YES;
    }
    else {
        cameraButton.hidden = YES;
        cameraLabel.hidden = YES;
    }
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"]){
        speakerButton.hidden = YES;
        speakerLabel.hidden = YES;
    }
    
    return overlayView;
}

- (id) overlayViewNib
{
    if (!_overlayViewNib) {
        Class nibDecoderClass = NSClassFromString(@"UINib");
        _overlayViewNib = [nibDecoderClass nibWithNibName:@"InCallOverlayView" bundle:[NSBundle mainBundle]];
    }
    
    return _overlayViewNib;
}

//we need to refresh our controls overlay
- (void) refreshControlsOverlayView:(UIView*)view inCallController:(Bit6InCallController*)icc
{
    UILabel *muteLabel = (UILabel*) [view viewWithTag:6];
    muteLabel.text = icc.isAudioMuted?@"Mute":@"Unmute";
    
    UILabel *speakerLabel = (UILabel*) [view viewWithTag:10];
    speakerLabel.text = [Bit6InCallController sharedInstance].isSpeakerEnabled?@"Disable Speaker":@"Enable Speaker";
}

- (void) refreshTimerInOverlayView:(UIView*)view inCallController:(Bit6InCallController*)icc
{
    UILabel *statusLabel = (UILabel*) [view viewWithTag:2];
    if (![Bit6InCallController sharedInstance].isConnected) {
        statusLabel.text = @"Connecting...";
    }
    else {
        int seconds = [Bit6InCallController sharedInstance].seconds;
        int minutes = seconds/60;
        statusLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds-minutes*60];
    }
}

@end
