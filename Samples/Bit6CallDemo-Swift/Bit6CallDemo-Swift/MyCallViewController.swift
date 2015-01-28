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
    
    var statusBarOrientation:UIInterfaceOrientation!
    
    init(callController: Bit6CallController) {
        super.init(nibName:"MyCallViewController", bundle:nil);
        
        self.callController = callController;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callStateChangedNotification:", name: Bit6CallStateChangedNotification, object: self.callController)
        self.callController.addObserver(self, forKeyPath:"seconds", options:.New, context:nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    deinit {
        self.callController.removeObserver(self, forKeyPath:"seconds");
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6ConversationsUpdatedNotification, object: nil)
        
    }
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = true
        UIApplication.sharedApplication().idleTimerDisabled = true
        
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
        
        self.controlsView.hidden = !(self.callController.callState == Bit6CallState.ANSWER)
        
        super.viewDidLoad()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func callStateChangedNotification(notification:NSNotification) -> Void {
        self.controlsView.hidden = !(self.callController.callState == Bit6CallState.ANSWER)
        self.refreshTimerLabel()
    }
    
    func refreshTimerLabel(){
        if (self.callController.callState == Bit6CallState.ANSWER) {
            self.timerLabel.text = Bit6Utils.clockFormatForSeconds(Double(self.callController.seconds))
        }
        else if (self.callController.callState == Bit6CallState.END || self.callController.callState == Bit6CallState.ERROR){
            self.timerLabel.text = "Disconnected";
        }
        else if (self.callController.callState == Bit6CallState.INTERRUPTED){
            self.timerLabel.text = "Interrupted";
        }
        else {
            self.timerLabel.text = "Connecting...";
        }
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
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        dispatch_async(dispatch_get_main_queue()) {
            if (object as Bit6CallController == self.callController) {
                if (keyPath == "seconds") {
                    self.refreshTimerLabel()
                }
            }
        }
    }
    
    // MARK: Bit6CallControllerDelegate
    
    override func refreshControlsViewForCallController(callController:Bit6CallController)
    {
        self.muteLabel.text = self.callController.audioMuted ?"Unmute":"Mute"
        self.speakerLabel.text = self.callController.speakerEnabled ?"Disable Speaker":"Enable Speaker"
        super.refreshControlsViewForCallController(callController)
    }
}
