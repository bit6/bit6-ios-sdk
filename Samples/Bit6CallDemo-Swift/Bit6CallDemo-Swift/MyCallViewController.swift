//
//  MyCallViewController.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber on 12/06/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import AVFoundation

class MyCallViewController: Bit6CallViewController {
    @IBOutlet var muteLabel:UILabel!
    @IBOutlet var speakerLabel:UILabel!
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var timerLabel:UILabel!
    @IBOutlet var cameraLabel:UILabel!
    
    @IBOutlet var speakerButton:UIButton!
    @IBOutlet var cameraButton:UIButton!
    
    @IBOutlet var controlsView:UIView!
    
    var statusBarOrientation:UIInterfaceOrientation!
    
    override init() {
        super.init(nibName:"MyCallViewController", bundle:nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        self.usernameLabel.text = self.callController.otherDisplayName
        
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
        
        self.controlsView.hidden = !(self.callController.callState == Bit6CallState.ANSWER)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated:Bool){
        UIApplication.sharedApplication().statusBarHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated:Bool) {
        UIApplication.sharedApplication().statusBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    // MARK: Bit6CallViewController methods
    
    override func refreshControlsView() {
        self.muteLabel.text = self.callController.audioMuted ?"Unmute":"Mute"
        self.speakerLabel.text = self.callController.speakerEnabled ?"Disable Speaker":"Enable Speaker"
    }
    
    override func callStateChangedNotification() {
        self.controlsView.hidden = !(self.callController.callState == Bit6CallState.ANSWER)
        self.secondsChangedNotification()
    }
    
    override func secondsChangedNotification() {
        switch (self.callController.callState) {
        case .NEW: fallthrough case .PROGRESS:
            self.timerLabel.text = "Connecting..."
        case .ANSWER:
            self.timerLabel.text = Bit6Utils.clockFormatForSeconds(Double(self.callController.seconds))
        case .DISCONNECTED:fallthrough case .END:fallthrough case .MISSED:fallthrough case .ERROR:
            self.timerLabel.text = "Disconnected"
        }
    }
    
    override func updateLayoutForRemoteVideoView(remoteVideoView:UIView, localVideoView:UIView, remoteVideoAspectRatio:CGSize, localVideoAspectRatio:CGSize)
    {
        super.updateLayoutForRemoteVideoView(remoteVideoView, localVideoView:localVideoView, remoteVideoAspectRatio:remoteVideoAspectRatio, localVideoAspectRatio:localVideoAspectRatio)
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
    
}
