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
    
    var callController : Bit6CallController {
        get {
            var callControllers = Bit6.callControllers()
            return callControllers.first as! Bit6CallController
        }
    }
    
    var statusBarOrientation:UIInterfaceOrientation!
    
    init() {
        super.init(nibName:"MyCallViewController", bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.muteLabel.text = Bit6CallController.audioMuted() ?"Unmute":"Mute"
        self.speakerLabel.text = Bit6CallController.speakerEnabled() ?"Disable Speaker":"Enable Speaker"
    }
    
    override func callStateChangedNotificationForCallController(callController: Bit6CallController!) {
        if (self.controlsView != nil) {
            self.controlsView.hidden = !(self.callController.callState == Bit6CallState.ANSWER)
            self.secondsChangedNotificationForCallController(callController)
        }
    }
    
    override func secondsChangedNotificationForCallController(callController: Bit6CallController!) {
        if (self.timerLabel != nil) {
            switch (self.callController.callState) {
            case .NEW: fallthrough case .PROGRESS:
                self.timerLabel.text = "Connecting..."
            case .ANSWER:
                self.timerLabel.text = Bit6Utils.clockFormatForSeconds(Double(self.callController.seconds))
            case .DISCONNECTED:fallthrough case .END:fallthrough case .MISSED:fallthrough case .ERROR:
                self.timerLabel.text = "Disconnected"
            }
        }
    }
    
    override func updateLayoutForVideoFeedViews(videoFeedViews: [AnyObject]!) {
        self.usernameLabel.text = self.callController.otherDisplayName
        self.usernameLabel.hidden = Bit6.callControllers().count>1
        self.timerLabel.hidden = self.usernameLabel.hidden;
        
        super.updateLayoutForVideoFeedViews(videoFeedViews)
    }
    
    // MARK: Actions
    
    @IBAction func switchCamera(sender : UIButton) {
        Bit6CallController.switchCamera()
    }
    
    @IBAction func muteCall(sender : UIButton) {
        Bit6CallController.switchMuteAudio()
    }
    
    @IBAction func hangup(sender : UIButton) {
        Bit6CallController.hangupAll()
    }
    
    @IBAction func speaker(sender : UIButton) {
        Bit6CallController.switchSpeaker()
    }
    
}
