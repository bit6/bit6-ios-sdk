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

class CircleButton : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.size.width/2.0
        super.layoutSubviews()
    }
    
    var on : Bool = false {
        didSet {
             refreshColor()
        }
    }
    
    override var enabled: Bool {
        didSet {
            refreshColor()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            refreshColor()
        }
    }
    
    func refreshColor() {
        if on {
            backgroundColor = UIColor(red:216/255.0, green:236/255.0, blue:255/255.0, alpha:1.0)
        }
        else if highlighted {
            backgroundColor = UIColor(red:216/255.0, green:236/255.0, blue:255/255.0, alpha:1.0)
        }
        else if !enabled {
            backgroundColor = UIColor.grayColor()
        }
        else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
}

class RoundedButton : UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        clipsToBounds = true
        layer.cornerRadius = 10
    }
}

class MyCallViewController: Bit6CallViewController {
    
    @IBOutlet var overlayView:UIView!
    @IBOutlet var controlsView:UIView!
    
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var timerLabel:UILabel!
    
    @IBOutlet var muteAudioButton:CircleButton!
    @IBOutlet var bluetoothButton:CircleButton!
    @IBOutlet var speakerButton:CircleButton!
//    @IBOutlet var muteVideoButton:CircleButton!
//    @IBOutlet var transferFileButton:CircleButton!
    @IBOutlet var cameraButton:CircleButton!
    
    override class func createForCall(callController:Bit6CallController) -> Bit6CallViewController {
        return MyCallViewController(nibName:"MyCallViewController", bundle:nil)
    }
    
    var callController : Bit6CallController? {
        get {
            return Bit6.callControllers().first
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshState()
        
        self.usernameLabel.text = Bit6.callControllers().count>1 ? "Many Destinations" : self.callController?.otherDisplayName
        
        bluetoothButton.setTitle("", forState:.Normal)
        bluetoothButton.setBackgroundImage(UIImage(named:"bluetooth"), forState:.Normal)
        speakerButton.setTitle("", forState:.Normal)
        speakerButton.setBackgroundImage(UIImage(named:"speaker"), forState:.Normal)
        muteAudioButton.setTitle("", forState:.Normal)
        muteAudioButton.setBackgroundImage(UIImage(named:"mute"), forState:.Normal)
//        muteVideoButton.titleLabel?.numberOfLines = 2
//        muteVideoButton.titleLabel?.textAlignment = .Center
//        muteVideoButton.setTitle("Mute\nVideo", forState:.Normal)
        cameraButton.setTitle("", forState:.Normal)
        cameraButton.setBackgroundImage(UIImage(named:"camera"), forState:.Normal)
        
        let tgr = UITapGestureRecognizer(target:self, action:#selector(MyCallViewController.overlayTapped(_:)))
        overlayView.addGestureRecognizer(tgr)
        
        let tgr2 = UITapGestureRecognizer(target:self, action:#selector(MyCallViewController.overlayTapped(_:)))
        view.addGestureRecognizer(tgr2)
        
        var atLeastOneCallConnected = false
        let callControllers = Bit6.callControllers()
        for call in callControllers {
            if call.state.rawValue >= Bit6CallState.CONNECTED.rawValue {
                atLeastOneCallConnected = true
                break
            }
        }
        
        controlsView.hidden = !atLeastOneCallConnected
    }
    
    func overlayTapped(tgr:UITapGestureRecognizer){
        var atLeastOneCallConnected = false
        var atLeastOneCallHasVideo = false
        
        let callControllers = Bit6.callControllers()
        for call in callControllers {
            if call.state.rawValue >= Bit6CallState.CONNECTED.rawValue {
                atLeastOneCallConnected = true
            }
            if call.hasVideo {
                atLeastOneCallHasVideo = true
            }
        }
        
        if (atLeastOneCallHasVideo) {
            if (!overlayView.hidden) {
                if (atLeastOneCallConnected) {
                    overlayView.hidden = !overlayView.hidden
                }
            }
            else {
                overlayView.hidden = !overlayView.hidden
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Bit6CallViewController methods
    
    override func callStateChangedNotificationForCall(callController: Bit6CallController) {
        if callController.state == .ERROR {
            let alert = UIAlertController(title:"An Error Occurred", message:nil, preferredStyle:.Alert)
            if let error = callController.error {
                alert.message = error.localizedDescription
            }
            alert.addAction(UIAlertAction(title:"OK", style:.Cancel, handler:nil))
            self.navigationController?.presentViewController(alert, animated:true, completion:nil)
        }
        
        refreshState()
        
        secondsChangedNotificationForCall(callController)
    }
    
    override func secondsChangedNotificationForCall(callController: Bit6CallController) {
        
        var longerCall : UInt = 0
        let callControllers = Bit6.callControllers()
        for call in callControllers {
            if call.seconds > longerCall {
                longerCall = call.seconds
            }
        }
        
        if callController.state == .CONNECTED {
            timerLabel.text = Bit6Utils.clockFormatForSeconds(Double(longerCall))
        }
    }
    
    func refreshState(){
        var atLeastOneCallConnected = false
        var smallerCall : Bit6CallController? = nil
        var smallerState = Bit6CallState.MISSED
        
        let callControllers = Bit6.callControllers()
        for call in callControllers {
            if call.state.rawValue < smallerState.rawValue {
                smallerState = call.state
                smallerCall = call
            }
            if call.state.rawValue >= Bit6CallState.CONNECTED.rawValue {
                atLeastOneCallConnected = true
            }
        }
        
        controlsView.hidden = !atLeastOneCallConnected
        
        if let smallerCall = smallerCall {
            if smallerCall.incoming {
                switch smallerState {
                case .NEW: fallthrough
                case .ACCEPTING_CALL:
                    timerLabel.text = "Answering Call..."
                case .WAITING_SDP:
                    timerLabel.text = "Waiting SDP..."
                case .GATHERING_CANDIDATES:
                    timerLabel.text = "Gathering Candidates..."
                case .SENDING_SDP:
                    timerLabel.text = "Sending SDP..."
                case .CONNECTING:
                    timerLabel.text = "Connecting..."
                case .CONNECTED: break
                case .DISCONNECTED:
                    timerLabel.text = "Disconnected"
                case .END: fallthrough
                default : break
                }
            }
            else {
                switch (smallerState) {
                case .NEW: fallthrough
                case .GATHERING_CANDIDATES:
                    timerLabel.text = "Gathering Candidates..."
                case .SENDING_SDP:
                    timerLabel.text = "Sending SDP..."
                case .WAITING_SDP:
                    timerLabel.text = "Waiting for Answer..."
                case .CONNECTING:
                    timerLabel.text = "Connecting..."
                case .CONNECTED: break;
                case .DISCONNECTED:
                    timerLabel.text = "Disconnected"
                case .END: fallthrough
                default: break;
                }
            }
        }
    }
    
    override func refreshControlsView() {
//        transferFileButton.enabled = false
        
        var atLeastOneCallHasVideo = false
        var atLeastOneCallHasAudio = false
        var atLeastOneCallHasRemoteAudio = false
        
        let callControllers = Bit6.callControllers()
        for call in callControllers {
            if call.hasVideo {
                atLeastOneCallHasVideo = true
            }
            if call.hasAudio {
                atLeastOneCallHasAudio = true
            }
            if call.hasRemoteAudio {
                atLeastOneCallHasRemoteAudio = true
            }
        }
        
        if (TARGET_OS_SIMULATOR != 0) {
//            muteVideoButton.enabled = false
            cameraButton.enabled = false
            bluetoothButton.enabled = false
            speakerButton.enabled = false
        }
        else {
//            muteVideoButton.enabled = atLeastOneCallHasVideo
            cameraButton.enabled = atLeastOneCallHasVideo
            bluetoothButton.enabled = atLeastOneCallHasRemoteAudio
            speakerButton.enabled = atLeastOneCallHasRemoteAudio
        }
        
        muteAudioButton.enabled = atLeastOneCallHasAudio
        
        
        let deviceType = UIDevice.currentDevice().model
        if deviceType != "iPhone" {
            speakerButton.enabled = false
        }
        
        if muteAudioButton.enabled {
            muteAudioButton.on = Bit6CallController.audioMuted()
        }
        if bluetoothButton.enabled {
            bluetoothButton.on = Bit6CallController.bluetoothEnabled()
        }
        if speakerButton.enabled {
            speakerButton.on = Bit6CallController.speakerEnabled()
        }
//        if muteVideoButton.enabled {
//            muteVideoButton.on = Bit6CallController.videoMuted()
//        }
    }
    
    override func updateLayoutForVideoFeedViews(videoFeedViews: [Bit6VideoFeedView]) {
        self.usernameLabel.text = Bit6.callControllers().count>1 ? "Many Destinations" : self.callController?.otherDisplayName
        super.updateLayoutForVideoFeedViews(videoFeedViews)
    }
    
    // MARK: Actions
    
    @IBAction func muteAudioCall(sender : UIButton) {
        Bit6CallController.switchMuteAudio()
    }
    
    @IBAction func bluetooth(sender : UIButton) {
        Bit6CallController.switchBluetooth()
    }
    
    @IBAction func speaker(sender : UIButton) {
        Bit6CallController.switchSpeaker()
    }
    
    @IBAction func muteVideoCall(sender : UIButton) {
        Bit6CallController.switchMuteVideo()
    }
    
    @IBAction func switchCamera(sender : UIButton) {
        Bit6CallController.switchCamera()
    }
    
    @IBAction func hangup(sender : UIButton) {
        Bit6CallController.hangupAll()
    }
    
}
