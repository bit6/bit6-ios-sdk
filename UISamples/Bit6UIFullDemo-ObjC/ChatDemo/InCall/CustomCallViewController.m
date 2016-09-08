//
//  BXUCallViewController.m
//  Bit6
//
//  Created by Carlos Thurber on 01/05/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "CustomCallViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CustomCallViewController ()

@property (weak, nonatomic) UILabel *noLocalFeedLabel;

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (weak, nonatomic) IBOutlet BXUContactNameLabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet BXUCircleButton *muteAudioButton;
@property (weak, nonatomic) IBOutlet BXUCircleButton *muteVideoButton;
@property (weak, nonatomic) IBOutlet BXUCircleButton *bluetoothButton;
@property (weak, nonatomic) IBOutlet BXUCircleButton *speakerButton;
@property (weak, nonatomic) IBOutlet BXUCircleButton *cameraButton;
@property (weak, nonatomic) IBOutlet BXUCircleButton *recordingCallButton;

@end

@implementation CustomCallViewController

+ (Bit6CallViewController*)createForCall:(Bit6CallController*)callController
{
    return [[BXUCallViewController alloc] initWithNibName:@"CustomCallViewController" bundle:nil];
}

- (Bit6CallController*) callController
{
    return [[Bit6 activeCalls] firstObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshState];
    
    if ([Bit6 activeCalls].count>1) {
        self.usernameLabel.address = nil;
        self.usernameLabel.text = @"Many Destinations";
    }
    else {
        self.usernameLabel.address = self.callController.other;
    }
    
    [self.bluetoothButton setTitle:@"" forState:UIControlStateNormal];
    [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"Bit6UIResources.bundle/bluetooth"] forState:UIControlStateNormal];
    [self.speakerButton setTitle:@"" forState:UIControlStateNormal];
    [self.speakerButton setBackgroundImage:[UIImage imageNamed:@"Bit6UIResources.bundle/speaker"] forState:UIControlStateNormal];
    [self.muteAudioButton setTitle:@"" forState:UIControlStateNormal];
    [self.muteAudioButton setBackgroundImage:[UIImage imageNamed:@"Bit6UIResources.bundle/mute"] forState:UIControlStateNormal];
    [self.muteVideoButton setTitle:@"" forState:UIControlStateNormal];
    [self.muteVideoButton setBackgroundImage:[UIImage imageNamed:@"Bit6UIResources.bundle/mute_video"] forState:UIControlStateNormal];
    [self.cameraButton setTitle:@"" forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"Bit6UIResources.bundle/camera"] forState:UIControlStateNormal];
    [self.recordingCallButton setTitle:@"" forState:UIControlStateNormal];
    [self.recordingCallButton setBackgroundImage:[UIImage imageNamed:@"Bit6UIResources.bundle/record_call"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    [self.overlayView addGestureRecognizer:tgr];
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    [self.view addGestureRecognizer:tgr2];
    
    BOOL atLeastOneCallConnected = NO;
    NSArray<Bit6CallController*>* callControllers = [Bit6 activeCalls];
    for (Bit6CallController *call in callControllers) {
        if (call.state >= Bit6CallState_CONNECTED) {
            atLeastOneCallConnected = YES; break;
        }
    }
    self.controlsView.hidden = !atLeastOneCallConnected;
}

- (void)overlayTapped:(UITapGestureRecognizer*)tgr
{
    BOOL atLeastOneCallConnected = NO;
    BOOL atLeastOneCallHasVideo = NO;
    NSArray<Bit6CallController*>* callControllers = [Bit6 activeCalls];
    for (Bit6CallController *call in callControllers) {
        if (call.state >= Bit6CallState_CONNECTED) {
            atLeastOneCallConnected = YES;
        }
        if (call.hasVideo) {
            atLeastOneCallHasVideo = YES;
        }
    }
    
    if (atLeastOneCallHasVideo) {
        if (!self.overlayView.hidden) {
            if (atLeastOneCallConnected) {
                self.overlayView.hidden = !self.overlayView.hidden;
            }
        }
        else {
            self.overlayView.hidden = !self.overlayView.hidden;
        }
    }
}

#pragma mark - Bit6CallControllerDelegate

- (void)callController:(Bit6CallController*)callController callDidChangeToState:(Bit6CallState)state
{
    [super callController:callController callDidChangeToState:state];
    
    if (callController.error) {
        [Bit6AlertView showAlertControllerWithTitle:callController.error.localizedDescription message:nil cancelButtonTitle:@"OK"];
    }
    
    [self refreshState];
    
    [self secondsDidChangeForCallController:callController];
}

- (void)secondsDidChangeForCallController:(Bit6CallController*)callController
{
    [super secondsDidChangeForCallController:callController];
    
    CGFloat longerCall = 0.0f;
    NSArray<Bit6CallController*>* callControllers = [Bit6 activeCalls];
    for (Bit6CallController *call in callControllers) {
        if (call.seconds > longerCall) {
            longerCall = call.seconds;
        }
    }
    
    if (self.callController.state == Bit6CallState_CONNECTED) {
        self.timerLabel.text = [Bit6Utils clockFormatForSeconds:longerCall];
    }
}

- (void)callController:(Bit6CallController*)callController localVideoFeedInterruptedBecause:(int)reason
{
    [super callController:callController localVideoFeedInterruptedBecause:reason];
    
    if (!self.noLocalFeedLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor grayColor];
        label.tag = 15;
        label.numberOfLines = 2;
        label.text = @"Video Feed\nUnavailable";
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        label.textColor = [UIColor whiteColor];
        
        [self.localVideoView addSubview:label];
        label.frame = self.localVideoView.bounds;
        self.noLocalFeedLabel = label;
    }
}

- (void)localVideoFeedInterruptionEndedForCallController:(Bit6CallController*)callController
{
    [super localVideoFeedInterruptionEndedForCallController:callController];
    
    [self.noLocalFeedLabel removeFromSuperview];
}

#pragma mark - Bit6CallViewController methods

- (void)refreshState
{
    Bit6CallController *smallerCall = nil;
    Bit6CallState smallerState = Bit6CallState_END;
    NSArray<Bit6CallController*>* callControllers = [Bit6 activeCalls];
    for (Bit6CallController *call in callControllers) {
        if (call.state < smallerState) {
            smallerState = call.state;
            smallerCall = call;
        }
        if (call.state == Bit6CallState_CONNECTED) {
            self.controlsView.hidden = NO;
        }
    }
    
    if (smallerCall.incoming) {
        switch (smallerState) {
            case Bit6CallState_NEW:
            case Bit6CallState_ACCEPTING_CALL:
                self.timerLabel.text = @"Answering Call..."; break;
            case Bit6CallState_WAITING_SDP:
                self.timerLabel.text = @"Waiting SDP..."; break;
            case Bit6CallState_GATHERING_CANDIDATES:
                self.timerLabel.text = @"Gathering Candidates..."; break;
            case Bit6CallState_SENDING_SDP:
                self.timerLabel.text = @"Sending SDP..."; break;
            case Bit6CallState_CONNECTING:
                self.timerLabel.text = @"Connecting..."; break;
            case Bit6CallState_CONNECTED: break;
            case Bit6CallState_DISCONNECTED:
                self.timerLabel.text = @"Disconnected"; break;
            case Bit6CallState_END:
            default: break;
        }
    }
    else {
        switch (smallerState) {
            case Bit6CallState_NEW:
            case Bit6CallState_GATHERING_CANDIDATES:
                self.timerLabel.text = @"Gathering Candidates..."; break;
            case Bit6CallState_SENDING_SDP:
                self.timerLabel.text = @"Sending SDP..."; break;
            case Bit6CallState_WAITING_SDP:
                self.timerLabel.text = @"Waiting for Answer..."; break;
            case Bit6CallState_CONNECTING:
                self.timerLabel.text = @"Connecting..."; break;
            case Bit6CallState_CONNECTED: break;
            case Bit6CallState_DISCONNECTED:
                self.timerLabel.text = @"Disconnected"; break;
            case Bit6CallState_END:
            default: break;
        }
    }
}

- (void)refreshControlsView
{
    BOOL atLeastOneCallHasVideo = NO;
    BOOL atLeastOneCallHasAudio = NO;
    BOOL atLeastOneCallHasRemoteAudio = NO;
    NSArray<Bit6CallController*>* callControllers = [Bit6 activeCalls];
    for (Bit6CallController *call in callControllers) {
        if (call.hasVideo) {
            atLeastOneCallHasVideo = YES;
        }
        if (call.hasAudio) {
            atLeastOneCallHasAudio = YES;
        }
        if (call.hasRemoteAudio) {
            atLeastOneCallHasRemoteAudio = YES;
        }
    }
    
    if (TARGET_OS_SIMULATOR) {
        self.muteVideoButton.enabled = NO;
        self.cameraButton.enabled = NO;
        self.bluetoothButton.enabled = NO;
        self.speakerButton.enabled = NO;
    }
    else {
        self.muteVideoButton.enabled = self.localVideoView.interrupted ? NO : atLeastOneCallHasVideo;
        self.cameraButton.enabled = atLeastOneCallHasVideo;
        self.bluetoothButton.enabled = atLeastOneCallHasRemoteAudio;
        self.speakerButton.enabled = atLeastOneCallHasRemoteAudio;
    }
    
    self.recordingCallButton.enabled = callControllers.count==1 && [self.callController supportsCapability:Bit6CallCapability_Recording];
    
    self.muteAudioButton.enabled = atLeastOneCallHasAudio;
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"]){
        self.speakerButton.enabled = NO;
    }
    
    if (self.muteAudioButton.enabled) {
        self.muteAudioButton.on = ![Bit6CallController isLocalAudioEnabled];
    }
    if (self.bluetoothButton.enabled) {
        self.bluetoothButton.on = [Bit6CallController isBluetoothEnabled];
    }
    if (self.speakerButton.enabled) {
        self.speakerButton.on = [Bit6CallController isSpeakerEnabled];
    }
    if (self.muteVideoButton.enabled) {
        self.muteVideoButton.on = ![Bit6CallController isLocalVideoEnabled];
    }
    if (self.recordingCallButton.enabled) {
        self.recordingCallButton.on = self.callController.recording;
    }
}

- (void)updateLayoutForVideoFeedViews:(NSArray*)videoFeedViews
{
    [super updateLayoutForVideoFeedViews:videoFeedViews];
    
    if ([Bit6 activeCalls].count>1) {
        self.usernameLabel.address = nil;
        self.usernameLabel.text = @"Many Destinations";
    }
    else {
        self.usernameLabel.address = self.callController.other;
    }
    
    self.noLocalFeedLabel.frame = self.localVideoView.bounds;
}

#pragma mark Actions

- (IBAction)muteAudioCall:(id)sender {
    [Bit6CallController setLocalAudioEnabled:!Bit6CallController.isLocalAudioEnabled];
}

- (IBAction)bluetooth:(id)sender {
    [Bit6CallController setBluetoothEnabled:!Bit6CallController.isBluetoothEnabled];
}

- (IBAction)speaker:(id)sender {
    [Bit6CallController setSpeakerEnabled:!Bit6CallController.isSpeakerEnabled];
}

- (IBAction)muteVideoCall:(id)sender {
    [Bit6CallController setLocalVideoEnabled:!Bit6CallController.isLocalVideoEnabled];
}

- (IBAction)switchCamera:(id)sender {
    [Bit6CallController setLocalVideoSource:[Bit6CallController localVideoSource]==Bit6VideoSource_CameraBack ? Bit6VideoSource_CameraFront : Bit6VideoSource_CameraBack];
}

- (IBAction)switchRecording:(id)sender {
    self.callController.recording = !self.callController.recording;
}

- (IBAction)hangup:(id)sender {
    [Bit6CallController hangupAll];
}

@end
