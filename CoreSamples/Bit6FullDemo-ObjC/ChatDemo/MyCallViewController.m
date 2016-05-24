//
//  BXUCallViewController.m
//  Bit6
//
//  Created by Carlos Thurber on 01/05/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "MyCallViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CircleButton : UIButton
@property (nonatomic) BOOL on;
@end

@interface RoundedButton : UIButton
@end

@implementation CircleButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    self.layer.cornerRadius = self.frame.size.width/2.0;
    [super layoutSubviews];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    [self refreshColor];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self refreshColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self refreshColor];
}

- (void)refreshColor
{
    if (self.on) {
        self.backgroundColor = [UIColor colorWithRed:216/255.0 green:236/255.0 blue:255/255.0 alpha:1.0];
    }
    else if (self.highlighted) {
        self.backgroundColor = [UIColor colorWithRed:216/255.0 green:236/255.0 blue:255/255.0 alpha:1.0];
    }
    else if (!self.enabled) {
        self.backgroundColor = [UIColor grayColor];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

@implementation RoundedButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
    }
    return self;
}

@end

@interface MyCallViewController ()

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet CircleButton *muteAudioButton;
@property (weak, nonatomic) IBOutlet CircleButton *bluetoothButton;
@property (weak, nonatomic) IBOutlet CircleButton *speakerButton;
@property (weak, nonatomic) IBOutlet CircleButton *cameraButton;

@end

@implementation MyCallViewController

+ (nonnull Bit6CallViewController*)createForCall:(nonnull Bit6CallController*)callController
{
    return [[MyCallViewController alloc] initWithNibName:@"MyCallViewController" bundle:nil];
}

- (Bit6CallController*) callController
{
    return [[Bit6 callControllers] firstObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshState];
    
    self.usernameLabel.text = [Bit6 callControllers].count>1 ? @"Many Destinations" : self.callController.otherDisplayName;
    
    [self.bluetoothButton setTitle:@"" forState:UIControlStateNormal];
    [self.bluetoothButton setBackgroundImage:[UIImage imageNamed:@"bluetooth"] forState:UIControlStateNormal];
    [self.speakerButton setTitle:@"" forState:UIControlStateNormal];
    [self.speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
    [self.muteAudioButton setTitle:@"" forState:UIControlStateNormal];
    [self.muteAudioButton setBackgroundImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    [self.cameraButton setTitle:@"" forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    [self.overlayView addGestureRecognizer:tgr];
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped:)];
    [self.view addGestureRecognizer:tgr2];
    
    BOOL atLeastOneCallConnected = NO;
    NSArray<Bit6CallController*>* callControllers = [[Bit6 callControllers] copy];
    for (Bit6CallController *call in callControllers) {
        if (call.state >= Bit6CallState_CONNECTED) {
            atLeastOneCallConnected = YES; break;
        }
    }
    self.controlsView.hidden = !atLeastOneCallConnected;
}

- (void) overlayTapped:(UITapGestureRecognizer*)tgr
{
    BOOL atLeastOneCallConnected = NO;
    BOOL atLeastOneCallHasVideo = NO;
    NSArray<Bit6CallController*>* callControllers = [[Bit6 callControllers] copy];
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Bit6CallViewController methods

- (void)callController:(Bit6CallController *)callController callDidChangeToState:(Bit6CallState)state
{
    [super callController:callController callDidChangeToState:state];
    
    if (callController.state == Bit6CallState_ERROR) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"An Error Occurred" message:callController.error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
    
    [self refreshState];
    
    [self secondsDidChangeForCallController:callController];
}

- (void)secondsDidChangeForCallController:(Bit6CallController *)callController
{
    [super secondsDidChangeForCallController:callController];
    
    NSUInteger longerCall = 0;
    NSArray<Bit6CallController*>* callControllers = [[Bit6 callControllers] copy];
    for (Bit6CallController *call in callControllers) {
        if (call.seconds > longerCall) {
            longerCall = call.seconds;
        }
    }
    
    if (callController.state == Bit6CallState_CONNECTED) {
        self.timerLabel.text = [Bit6Utils clockFormatForSeconds:longerCall];
    }
}

- (void)refreshState
{
    Bit6CallController *smallerCall = nil;
    Bit6CallState smallerState = Bit6CallState_MISSED;
    NSArray<Bit6CallController*>* callControllers = [[Bit6 callControllers] copy];
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
            case Bit6CallState_ERROR:
            case Bit6CallState_END:
            default: break;
        }
    }
}

- (void) refreshControlsView
{
    BOOL atLeastOneCallHasVideo = NO;
    BOOL atLeastOneCallHasAudio = NO;
    BOOL atLeastOneCallHasRemoteAudio = NO;
    NSArray<Bit6CallController*>* callControllers = [[Bit6 callControllers] copy];
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
        self.cameraButton.enabled = NO;
        self.bluetoothButton.enabled = NO;
        self.speakerButton.enabled = NO;
    }
    else {
        self.cameraButton.enabled = atLeastOneCallHasVideo;
        self.bluetoothButton.enabled = atLeastOneCallHasRemoteAudio;
        self.speakerButton.enabled = atLeastOneCallHasRemoteAudio;
    }
    
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
}

- (void)updateLayoutForVideoFeedViews:(NSArray<Bit6VideoFeedView*>*)videoFeedViews
{
    self.usernameLabel.text = [Bit6 callControllers].count>1 ? @"Many Destinations" : self.callController.otherDisplayName;
    
    [super updateLayoutForVideoFeedViews:videoFeedViews];
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

- (IBAction)switchCamera:(id)sender {
    [Bit6CallController setLocalVideoSource:[Bit6CallController localVideoSource]==Bit6VideoSource_CameraBack ? Bit6VideoSource_CameraFront : Bit6VideoSource_CameraBack];
}

- (IBAction)hangup:(id)sender {
    [Bit6CallController hangupAll];
}

@end