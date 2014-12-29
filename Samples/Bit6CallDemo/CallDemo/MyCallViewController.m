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
{
    CGSize _localVideoSize;
    CGSize _remoteVideoSize;
}

@property (nonatomic, strong) Bit6CallController *callController;

@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (nonatomic, strong) UIView* localVideoView;
@property (nonatomic, strong) UIView* remoteVideoView;

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
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimerLabel) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self setupCaptureSession];
    
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
    
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) callStateChangedNotification:(NSNotification*)notification
{
    if (self.callController.callState == Bit6CallState_ANSWER) {
        self.controlsView.hidden = NO;
    }
    else if (self.callController.callState == Bit6CallState_END || self.callController.callState == Bit6CallState_ERROR) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void) refreshTimerLabel
{
    if (self.callController.callState == Bit6CallState_ANSWER) {
        NSUInteger seconds = self.callController.seconds;
        NSUInteger minutes = seconds/60;
        self.timerLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,seconds-minutes*60];
    }
    else {
        self.timerLabel.text = @"Connecting...";
    }
}

#pragma mark - PREPARE VIDEO

// Padding space for local video view with its parent.
static CGFloat const kLocalViewPadding = 20;

- (void)setupCaptureSession {
    if (self.callController.hasVideo) {
        self.remoteVideoView = [Bit6CallController createVideoTrackViewWithFrame:self.videoView.bounds delegate:self];
        self.remoteVideoView.transform = CGAffineTransformMakeScale(-1, 1);
        [self.videoView addSubview:self.remoteVideoView];
        
        self.localVideoView = [Bit6CallController createVideoTrackViewWithFrame:self.videoView.bounds delegate:self];
        [self.videoView addSubview:self.localVideoView];
        [self updateVideoViewLayout];
    }
    else {
        self.videoView.hidden = YES;
    }
}

- (void)updateVideoViewLayout {
    // TODO(tkchin): handle rotation.
    CGSize defaultAspectRatio = CGSizeMake(4, 3);
    CGSize localAspectRatio = CGSizeEqualToSize(_localVideoSize, CGSizeZero) ? defaultAspectRatio : _localVideoSize;
    CGSize remoteAspectRatio = CGSizeEqualToSize(_remoteVideoSize, CGSizeZero) ? defaultAspectRatio : _remoteVideoSize;
    
    CGRect remoteVideoFrame = AVMakeRectWithAspectRatioInsideRect(remoteAspectRatio, self.videoView.bounds);
    self.remoteVideoView.frame = remoteVideoFrame;
    
    CGRect localVideoFrame = AVMakeRectWithAspectRatioInsideRect(localAspectRatio, self.videoView.bounds);
    localVideoFrame.size.width = localVideoFrame.size.width / 3;
    localVideoFrame.size.height = localVideoFrame.size.height / 3;
    localVideoFrame.origin.x = CGRectGetMaxX(self.videoView.bounds) - localVideoFrame.size.width - kLocalViewPadding;
    localVideoFrame.origin.y = CGRectGetMaxY(self.videoView.bounds) - localVideoFrame.size.height - kLocalViewPadding;
    self.localVideoView.frame = localVideoFrame;
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

- (UIView*)localVideoTrackViewForCallController:(Bit6CallController*)callController
{
    return self.localVideoView;
}

- (UIView*)remoteVideoTrackViewForCallController:(Bit6CallController*)callController
{
    return self.remoteVideoView;
}

- (void) refreshControlsViewForCallController:(Bit6CallController*)callController
{
    self.muteLabel.text = self.callController.audioMuted?@"Unmute":@"Mute";
    self.speakerLabel.text = self.callController.speakerEnabled?@"Disable Speaker":@"Enable Speaker";
}

- (void)videoView:(UIView*)videoView didChangeVideoSize:(CGSize)size {
    if (videoView == self.localVideoView) {
        _localVideoSize = size;
    } else if (videoView == self.remoteVideoView) {
        _remoteVideoSize = size;
    } else {
        
    }
    [self updateVideoViewLayout];
}

@end
