//
//  MyCallViewController.m
//  FullDemo
//
//  Created by Carlos Thurber on 12/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "MyCallViewController.h"

@interface MyCallViewController ()

@property (weak, nonatomic) IBOutlet UILabel *muteLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;

@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@end

@implementation MyCallViewController

- (instancetype)init
{
    self = [super initWithNibName:@"MyCallViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    self.usernameLabel.text = self.callController.otherDisplayName;
    
    if (self.callController.hasVideo) {
        self.speakerButton.hidden = YES;
        self.speakerLabel.hidden = YES;
    }
    else {
        self.cameraButton.hidden = YES;
        self.cameraLabel.hidden = YES;
    }
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"]){
        self.speakerButton.hidden = YES;
        self.speakerLabel.hidden = YES;
    }
    
    self.controlsView.hidden = !(self.callController.callState == Bit6CallState_ANSWER);
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - Bit6CallViewController methods

- (void) refreshControlsView
{
    self.muteLabel.text = self.callController.audioMuted?@"Unmute":@"Mute";
    self.speakerLabel.text = self.callController.speakerEnabled?@"Disable Speaker":@"Enable Speaker";
}

- (void) callStateChangedNotification
{
    self.controlsView.hidden = !(self.callController.callState == Bit6CallState_ANSWER);
    [self secondsChangedNotification];
}

- (void) secondsChangedNotification
{
    switch (self.callController.callState) {
        case Bit6CallState_NEW: case Bit6CallState_PROGRESS:
            self.timerLabel.text = @"Connecting..."; break;
        case Bit6CallState_ANSWER:
            self.timerLabel.text = [Bit6Utils clockFormatForSeconds:self.callController.seconds]; break;
        case Bit6CallState_END: case Bit6CallState_MISSED: case Bit6CallState_ERROR: case Bit6CallState_DISCONNECTED:
            self.timerLabel.text = @"Disconnected"; break;
    }
}

- (void)updateLayoutForRemoteVideoView:(UIView*)remoteVideoView localVideoView:(UIView*)localVideoView remoteVideoAspectRatio:(CGSize)remoteVideoAspectRatio localVideoAspectRatio:(CGSize)localVideoAspectRatio
{
    [super updateLayoutForRemoteVideoView:remoteVideoView localVideoView:localVideoView remoteVideoAspectRatio:remoteVideoAspectRatio localVideoAspectRatio:localVideoAspectRatio];
}

#pragma mark Actions

- (IBAction)switchCamera:(id)sender {
    [self.callController switchCamera];
}

- (IBAction)muteCall:(id)sender {
    [self.callController switchMuteAudio];
}

- (IBAction)hangup:(id)sender {
    [self.callController hangup];
}

- (IBAction)speaker:(id)sender {
    [self.callController switchSpeaker];
}

@end
