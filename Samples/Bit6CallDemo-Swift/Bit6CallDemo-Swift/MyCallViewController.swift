//
//  MyCallViewController.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber on 12/06/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import AVFoundation

class MyCallViewController: UIViewController, Bit6CallControllerDelegate {
    var localVideoSize : CGSize!
    var remoteVideoSize : CGSize!
    
    var callController:Bit6CallController!
    var timer:NSTimer!
    
    @IBOutlet var videoView:UIView!
    var localVideoView:UIView!
    var remoteVideoView:UIView!
    
    @IBOutlet var muteLabel:UILabel!
    @IBOutlet var speakerLabel:UILabel!
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var timerLabel:UILabel!
    @IBOutlet var cameraLabel:UILabel!
    
    @IBOutlet var speakerButton:UIButton!
    @IBOutlet var cameraButton:UIButton!
    
    @IBOutlet var controlsView:UIView!
    
    init(callController: Bit6CallController) {
        super.init(nibName:"MyCallViewController", bundle:nil);
        
        self.callController = callController;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callStateChangedNotification:", name: Bit6CallStateChangedNotification, object: self.callController)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "refreshTimerLabel", userInfo: nil, repeats: true)
        self.localVideoSize = CGSizeZero
        self.remoteVideoSize = CGSizeZero
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6ConversationsUpdatedNotification, object: nil)
        
    }
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = true
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        self.setupCaptureSession()
        
        self.usernameLabel.text = self.callController.other

        self.refreshTimerLabel()
        
        if (self.callController.hasVideo) {
            self.speakerButton.hidden = true
            self.speakerLabel.hidden = true
        }
        else {
            self.cameraButton.hidden = true
            self.cameraLabel.hidden = true
        }
        
        var deviceType : NSString = UIDevice.currentDevice().model
        if ( deviceType.isEqualToString("iPhone") ) {
            self.speakerButton.hidden = true
            self.speakerLabel.hidden = true
        }
        
        super.viewDidLoad()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func callStateChangedNotification(notification:NSNotification) -> Void {
        if (self.callController.callState == Bit6CallState.ANSWER) {
            self.controlsView.hidden = false
        }
        else if (self.callController.callState == Bit6CallState.END || callController.callState == Bit6CallState.ERROR) {
            if (timer.valid) {
                timer.invalidate()
            }
            timer = nil
        }
    }
    
    func refreshTimerLabel(){
        if (self.callController.callState == Bit6CallState.ANSWER) {
            var seconds = self.callController.seconds
            var minutes = seconds/60;
            
            var minutesStr = NSString(format: "%02d", minutes)
            var secondsStr = NSString(format: "%02d", (seconds-minutes*60) )
            self.timerLabel.text = "\(minutesStr):\(secondsStr)";
        }
        else {
            self.timerLabel.text = "Connecting..."
        }
    }
    
    // MARK: PREPARE VIDEO
    
    func setupCaptureSession() {
        if (self.callController.hasVideo) {
            self.remoteVideoView = Bit6CallController.createVideoTrackViewWithFrame(self.videoView.bounds, delegate:self)
            self.remoteVideoView.transform = CGAffineTransformMakeScale(-1, 1);
            self.videoView.addSubview(self.remoteVideoView)
            
            self.localVideoView = Bit6CallController.createVideoTrackViewWithFrame(self.videoView.bounds, delegate:self)
            self.videoView.addSubview(self.localVideoView)
            self.updateVideoViewLayout()
        }
        else {
            self.videoView.hidden = true
        }
    }
    
    func updateVideoViewLayout () {
        // Padding space for local video view with its parent.
        var kLocalViewPadding : CGFloat = 20.0
        
        // TODO(tkchin): handle rotation.
        var defaultAspectRatio = CGSizeMake(4, 3);
        var localAspectRatio = CGSizeEqualToSize(self.localVideoSize, CGSizeZero) ? defaultAspectRatio : self.localVideoSize;
        var remoteAspectRatio = CGSizeEqualToSize(self.remoteVideoSize, CGSizeZero) ? defaultAspectRatio : self.remoteVideoSize;
        
        var remoteVideoFrame = AVMakeRectWithAspectRatioInsideRect(remoteAspectRatio, self.videoView.bounds);
        self.remoteVideoView.frame = remoteVideoFrame;
        
        var localVideoFrame = AVMakeRectWithAspectRatioInsideRect(localAspectRatio, self.videoView.bounds);
        localVideoFrame.size.width = localVideoFrame.size.width / 3;
        localVideoFrame.size.height = localVideoFrame.size.height / 3;
        localVideoFrame.origin.x = CGRectGetMaxX(self.videoView.bounds) - localVideoFrame.size.width - kLocalViewPadding;
        localVideoFrame.origin.y = CGRectGetMaxY(self.videoView.bounds) - localVideoFrame.size.height - kLocalViewPadding;
        self.localVideoView.frame = localVideoFrame;
    }
    
    // MARK: Actions
    
    @IBAction func switchCamera(sender : UIButton) {
        self.callController.switchCamera()
    }
    
    @IBAction func muteCall(sender : UIButton) {
        self.callController.switchMuteAudio()
    }
    
    @IBAction func hangup(sender : UIButton) {
        self.callController.hangup()
    }
    
    @IBAction func speaker(sender : UIButton) {
        self.callController.switchSpeaker()
    }
    
    // MARK: Bit6CallControllerDelegate
    
    func localVideoTrackViewForCallController(callController:Bit6CallController) -> UIView
    {
        return self.localVideoView
    }
    
    func remoteVideoTrackViewForCallController(callController:Bit6CallController) -> UIView
    {
        return self.remoteVideoView
    }
    
    func refreshControlsViewForCallController(callController:Bit6CallController)
    {
        self.muteLabel.text = self.callController.audioMuted ?"Unmute":"Mute"
        self.speakerLabel.text = self.callController.speakerEnabled ?"Disable Speaker":"Enable Speaker"
    }
    
    func videoView(videoView:UIView, didChangeVideoSize size:CGSize) {
        if (videoView == self.localVideoView) {
            self.localVideoSize = size
        }
        else if (videoView == self.remoteVideoView) {
            self.remoteVideoSize = size
        }
        self.updateVideoViewLayout()
    }
}
