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

- (Bit6CallController*) callController
{
    return [[Bit6 callControllers] firstObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.controlsView.hidden = !(self.callController.callState == Bit6CallState_CONNECTED);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Bit6CallViewController methods

- (void) refreshControlsView
{
    self.muteLabel.text = [Bit6CallController audioMuted]?@"Unmute":@"Mute";
    self.speakerLabel.text = [Bit6CallController speakerEnabled]?@"Disable Speaker":@"Enable Speaker";
}

- (void) callStateChangedNotificationForCallController:(Bit6CallController*)callController
{
    self.controlsView.hidden = !(self.callController.callState == Bit6CallState_CONNECTED);
    [self secondsChangedNotificationForCallController:callController];
}

- (void) secondsChangedNotificationForCallController:(Bit6CallController*)callController
{
    switch (self.callController.callState) {
        case Bit6CallState_NEW: case Bit6CallState_ACCEPTING_CALL: case Bit6CallState_GATHERING_CANDIDATES: case Bit6CallState_WAITING_SDP: case Bit6CallState_SENDING_SDP: case Bit6CallState_CONNECTING:
            self.timerLabel.text = @"Connecting..."; break;
        case Bit6CallState_CONNECTED:
            self.timerLabel.text = [Bit6Utils clockFormatForSeconds:self.callController.seconds]; break;
        case Bit6CallState_END: case Bit6CallState_MISSED: case Bit6CallState_ERROR: case Bit6CallState_DISCONNECTED:
            self.timerLabel.text = @"Disconnected"; break;
    }
}

- (void)updateLayoutForVideoFeedViews:(NSArray<Bit6VideoFeedView*>*)videoFeedViews
{
    self.usernameLabel.text = self.callController.otherDisplayName;
    self.usernameLabel.hidden = [Bit6 callControllers].count>1;
    self.timerLabel.hidden = self.usernameLabel.hidden;
    
    [super updateLayoutForVideoFeedViews:videoFeedViews];
}

#pragma mark Actions

- (IBAction)switchCamera:(id)sender {
    [Bit6CallController switchCamera];
}

- (IBAction)muteCall:(id)sender {
    [Bit6CallController switchMuteAudio];
}

- (IBAction)hangup:(id)sender {
    [Bit6CallController hangupAll];
}

- (IBAction)speaker:(id)sender {
    [Bit6CallController switchSpeaker];
}

@end
