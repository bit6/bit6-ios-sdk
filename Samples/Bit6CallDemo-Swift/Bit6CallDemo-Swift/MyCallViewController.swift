//
//  MyCallViewController.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber on 12/06/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import AVFoundation
import Bit6

class MyCallViewController: Bit6CallViewController {
    @IBOutlet var muteLabel:UILabel!
    @IBOutlet var speakerLabel:UILabel!
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var timerLabel:UILabel!
    @IBOutlet var cameraLabel:UILabel!
    
    @IBOutlet var speakerButton:UIButton!
    @IBOutlet var cameraButton:UIButton!
    
    @IBOutlet var controlsView:UIView!
    
    var callController : Bit6CallController? {
        get {
            return Bit6.callControllers().first
        }
    }
    
    var statusBarOrientation:UIInterfaceOrientation!
    
    init() {
        super.init(nibName:"MyCallViewController", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = self.callController!.otherDisplayName
        
        if self.callController!.hasVideo {
            self.speakerButton.hidden = true
            self.speakerLabel.hidden = true
        }
        else {
            self.cameraButton.hidden = true
            self.cameraLabel.hidden = true
        }
        
        let deviceType = UIDevice.currentDevice().model
        if deviceType == "iPhone" {
            self.speakerButton.hidden = true
            self.speakerLabel.hidden = true
        }
        
        self.controlsView.hidden = !(self.callController!.callState == .CONNECTED)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Bit6CallViewController methods
    
    override func refreshControlsView() {
        self.muteLabel.text = Bit6CallController.audioMuted() ?"Unmute":"Mute"
        self.speakerLabel.text = Bit6CallController.speakerEnabled() ?"Disable Speaker":"Enable Speaker"
    }
    
    override func callStateChangedNotificationForCallController(callController: Bit6CallController) {
        guard let firstCallController = self.callController else { return }
        
        if self.controlsView != nil {
            self.controlsView.hidden = !(firstCallController.callState == .CONNECTED)
            self.secondsChangedNotificationForCallController(firstCallController)
        }
    }
    
    override func secondsChangedNotificationForCallController(callController: Bit6CallController) {
        guard let callController = self.callController else { return }
        
        if self.timerLabel != nil {
            switch (callController.callState) {
            case .NEW: fallthrough case .ACCEPTING_CALL: fallthrough case .GATHERING_CANDIDATES: fallthrough case .WAITING_SDP: fallthrough case .SENDING_SDP: fallthrough case .CONNECTING:
                self.timerLabel.text = "Connecting..."
            case .CONNECTED:
                self.timerLabel.text = Bit6Utils.clockFormatForSeconds(Double(callController.seconds))
            case .DISCONNECTED:fallthrough case .END:fallthrough case .MISSED:fallthrough case .ERROR:
                self.timerLabel.text = "Disconnected"
            }
        }
    }
    
    override func updateLayoutForVideoFeedViews(videoFeedViews: [Bit6VideoFeedView]) {
        self.usernameLabel.text = self.callController!.otherDisplayName
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
