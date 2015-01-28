//
//  MyCallViewController.m
//  FullDemo
//
//  Created by Carlos Thurber on 12/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "MyCallViewController.h"
#import <AVFoundation/AVFoundation.h>

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

- (instancetype)initWithCallController:(Bit6CallController*)callController
{
    self = [super initWithNibName:@"MyCallViewController" bundle:nil];
    if (self) {
        self.callController = callController;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateChangedNotification:) name:Bit6CallStateChangedNotification object:self.callController];
        [self.callController addObserver:self forKeyPath:@"seconds" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self.callController removeObserver:self forKeyPath:@"seconds"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.usernameLabel.text = self.callController.other;
    [self refreshTimerLabel];
    
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) callStateChangedNotification:(NSNotification*)notification
{
    self.controlsView.hidden = !(self.callController.callState == Bit6CallState_ANSWER);
    [self refreshTimerLabel];
}

- (void) refreshTimerLabel
{
    if (self.callController.callState == Bit6CallState_ANSWER) {
        self.timerLabel.text = [Bit6Utils clockFormatForSeconds:self.callController.seconds];
    }
    else if (self.callController.callState == Bit6CallState_END || self.callController.callState == Bit6CallState_ERROR){
        self.timerLabel.text = @"Disconnected";
    }
    else if (self.callController.callState == Bit6CallState_INTERRUPTED){
        self.timerLabel.text = @"Interrupted";
    }
    else {
        self.timerLabel.text = @"Connecting...";
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object == self.callController) {
            if ([keyPath isEqualToString:@"seconds"]) {
                [self refreshTimerLabel];
            }
        }
    });
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

#pragma mark - Bit6CallControllerDelegate

- (void) refreshControlsViewForCallController:(Bit6CallController*)callController
{
    self.muteLabel.text = self.callController.audioMuted?@"Unmute":@"Mute";
    self.speakerLabel.text = self.callController.speakerEnabled?@"Disable Speaker":@"Enable Speaker";
    [super refreshControlsViewForCallController:callController];
}

@end
