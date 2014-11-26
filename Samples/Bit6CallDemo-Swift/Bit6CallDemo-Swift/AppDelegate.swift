//
//  AppDelegate.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/30/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: Bit6ApplicationManager, UIApplicationDelegate, Bit6InCallControllerDelegate {
    
    var window: UIWindow?
    var overlayViewNib: UINib {
        get {
            return UINib(nibName: "InCallOverlayView", bundle: NSBundle.mainBundle())
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        let apikey : NSString = "your_api_key";
        Bit6.startWithApiKey(apikey, pushNotificationMode: Bit6PushNotificationMode.DEVELOPMENT, launchingWithOptions: launchOptions);
        
        //set this if you want customize the controls overlay in the inCall screen
//        Bit6InCallController.sharedInstance().delegate = self;
        
        return true
    }
    
    //here we make our own control overlay with destination, call status and mute/camera/hangup buttons
    func controlsOverlayViewForInCallController(icc:Bit6InCallController) -> UIView! {
    
        var topLevelNibObjects : NSArray! = self.overlayViewNib.instantiateWithOwner(self, options: nil)
        
        if (topLevelNibObjects != nil) {
            var topLevelObject = topLevelNibObjects!
            
            var overlayView = topLevelObject[0] as UIView
            
            var displayNameLabel = overlayView.viewWithTag(1) as UILabel
//            var statusLabel = overlayView.viewWithTag(2) as UILabel
            var cameraButton = overlayView.viewWithTag(3) as UIButton
            var cameraLabel = overlayView.viewWithTag(4) as UILabel
            var muteButton = overlayView.viewWithTag(5) as UIButton
//            var muteLabel = overlayView.viewWithTag(6) as UILabel
            var hangupButton = overlayView.viewWithTag(7) as UIButton
//            var hangupLabel = overlayView.viewWithTag(8) as UILabel
            var speakerButton = overlayView.viewWithTag(9) as UIButton
            var speakerLabel = overlayView.viewWithTag(10) as UILabel
            
            displayNameLabel.text = icc.displayName
        
            cameraButton.addTarget(icc, action: "switchCamera", forControlEvents: UIControlEvents.TouchUpInside)
            muteButton.addTarget(icc, action: "muteAudio", forControlEvents: UIControlEvents.TouchUpInside)
            hangupButton.addTarget(icc, action: "hangup", forControlEvents: UIControlEvents.TouchUpInside)
            speakerButton.addTarget(icc, action: "switchSpeaker", forControlEvents: UIControlEvents.TouchUpInside)
            
            if (icc.videoCall){
                speakerButton.hidden = true;
                speakerLabel.hidden = true;
            }
            else {
                cameraButton.hidden = true;
                cameraLabel.hidden = true;
            }
            
            var deviceType : NSString = UIDevice.currentDevice().model
            if (deviceType.isEqualToString("iPhone")){
                speakerButton.hidden = true;
                speakerLabel.hidden = true;
            }
            
            return overlayView;
        }
        else {
            return nil;
        }
    }
    
    //we need to refresh our controls overlay
    func refreshControlsOverlayView(view:UIView, inCallController icc:Bit6InCallController) -> Void {
        var muteLabel = view.viewWithTag(6) as UILabel
        muteLabel.text = icc.audioMuted ?"Unmute":"Mute"
     
        var speakerLabel = view.viewWithTag(10) as UILabel
        muteLabel.text = icc.speakerEnabled ?"Disable Speaker":"Enable Speaker"
    }
    
    func refreshTimerInOverlayView(view:UIView, inCallController icc:Bit6InCallController) -> Void {
        var statusLabel = view.viewWithTag(2) as UILabel
        if (!icc.connected){
            statusLabel.text = "Connecting...";
        }
        else {
            var seconds = icc.seconds
            var minutes = seconds/60
            statusLabel.text = String(format:"%02d:%02d",minutes,seconds-minutes*60)
        }
    }
}

