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
    
    override func callController(callController: Bit6CallController, callDidChangeToState state: Bit6CallState) {
        super.callController(callController, callDidChangeToState:state)
        
        if callController.state == .ERROR {
            let alert = UIAlertController(title:"An Error Occurred", message:nil, preferredStyle:.Alert)
            if let error = callController.error {
                alert.message = error.localizedDescription
            }
            alert.addAction(UIAlertAction(title:"OK", style:.Cancel, handler:nil))
            self.navigationController?.presentViewController(alert, animated:true, completion:nil)
        }
        
        if isViewLoaded() {
            refreshState()
        }
        
        secondsDidChangeForCallController(callController)
    }
    
    override func secondsDidChangeForCallController(callController: Bit6CallController) {
        super.secondsDidChangeForCallController(callController)
        
        if isViewLoaded() {
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
    }
    
    func refreshState(){
        var smallerCall : Bit6CallController? = nil
        var smallerState = Bit6CallState.MISSED
        
        let callControllers = Bit6.callControllers()
        for call in callControllers {
            if call.state.rawValue < smallerState.rawValue {
                smallerState = call.state
                smallerCall = call
            }
            if call.state == Bit6CallState.CONNECTED {
                controlsView.hidden = false
            }
        }
        
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
            cameraButton.enabled = false
            bluetoothButton.enabled = false
            speakerButton.enabled = false
        }
        else {
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
            muteAudioButton.on = !Bit6CallController.isLocalAudioEnabled()
        }
        if bluetoothButton.enabled {
            bluetoothButton.on = Bit6CallController.isBluetoothEnabled()
        }
        if speakerButton.enabled {
            speakerButton.on = Bit6CallController.isSpeakerEnabled()
        }
    }
    
    override func updateLayoutForVideoFeedViews(videoFeedViews: [Bit6VideoFeedView]) {
        self.usernameLabel.text = Bit6.callControllers().count>1 ? "Many Destinations" : self.callController?.otherDisplayName
        super.updateLayoutForVideoFeedViews(videoFeedViews)
    }
    
    // MARK: Actions
    
    @IBAction func muteAudioCall(sender : UIButton) {
        Bit6CallController.setLocalAudioEnabled(!Bit6CallController.isLocalAudioEnabled())
    }
    
    @IBAction func bluetooth(sender : UIButton) {
        Bit6CallController.setBluetoothEnabled(!Bit6CallController.isBluetoothEnabled())
    }
    
    @IBAction func speaker(sender : UIButton) {
        Bit6CallController.setSpeakerEnabled(!Bit6CallController.isSpeakerEnabled())
    }
    
    @IBAction func switchCamera(sender : UIButton) {
        Bit6CallController.setLocalVideoSource(Bit6CallController.localVideoSource() == .CameraBack ? .CameraFront : .CameraBack)
    }
    
    @IBAction func hangup(sender : UIButton) {
        Bit6CallController.hangupAll()
    }
    
}
