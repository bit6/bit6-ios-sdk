//
//  AppDelegate.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/30/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import AudioToolbox
import Bit6

//WARNING: Remember to set your api key
let BIT6_API_KEY = "BIT6_API_KEY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Bit6IncomingCallHandlerDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        assert(BIT6_API_KEY != "BIT6_API_KEY", "[Bit6 SDK]: Setup your Bit6 api key.")
        
        //uncomment to handle the incoming call
        //Bit6.incomingCallHandler().delegate = self
        
        Bit6.startWithApiKey(BIT6_API_KEY)
        
        if let remoteNotificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            Bit6.pushNotification().didReceiveRemoteNotification(remoteNotificationPayload as [NSObject : AnyObject])
        }
        
        return true
    }
    
    // MARK: - Notifications
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        Bit6.pushNotification().didReceiveRemoteNotification(userInfo)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Bit6.pushNotification().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Bit6.pushNotification().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    // MARK: - Bit6IncomingCallHandlerDelegate
    
    /*
    //use a custom in-call UIViewController
    func inCallViewController() -> Bit6CallViewController
    {
        //if there's another call on the way, we are going to merge the callcontrollers into one viewcontroller
        if let callViewController = Bit6.callViewController() {
            return callViewController
        }
        else {
            //custom view controller
            return MyCallViewController()
            
            //default view controller
            //return Bit6CallViewController.createDefaultCallViewController()
        }
    }
    
    //customize in-app incoming call prompt
    func incomingCallPromptContentViewForCallController(callController: Bit6CallController) -> UIView? {
        let numberOfStreams = (callController.hasRemoteAudio ? 1 : 0) + (callController.hasRemoteVideo ? 1 : 0) + (callController.hasRemoteData ? 1 : 0)
        let numberOfButtons = numberOfStreams == 3 ? 3 : numberOfStreams > 0 ? (numberOfStreams + 1) : 2
        
        let title = callController.incomingCallAlert
        
        let WIDTH = CGFloat(290)
        let size = CGSizeMake(WIDTH,130)
        
        var frame = UIScreen.mainScreen().bounds
        frame.origin.x = (frame.size.width-size.width)/2
        frame.origin.y = (frame.size.height-size.height)/2
        frame.size.width = size.width
        frame.size.height = size.height
        
        let contentView = UIView(frame:frame)
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red:251/255.0, green:249/255.0, blue:224/255.0, alpha:1.0)
        
        let labelMargin = CGFloat(13)
        let titleLabel = UILabel(frame:CGRectMake(labelMargin, labelMargin, size.width-labelMargin*2, 20))
        titleLabel.textColor = UIColor(red:132/255.0, green:105/255.0, blue:56/255.0, alpha:1.0)
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        
        let msgLabel = UILabel(frame:CGRectZero)
        frame = titleLabel.frame;
        frame.origin.y = CGRectGetMaxY(frame)+13;
        msgLabel.frame = frame;
        msgLabel.textColor = UIColor(red:132/255.0, green:105/255.0, blue:56/255.0, alpha:1.0)
        msgLabel.font = UIFont.systemFontOfSize(15.0)
        msgLabel.text = "Do you dare to answer this call?"
        contentView.addSubview(msgLabel)
        
        let buttonSeparationX = CGFloat(12.5)
        let buttonWidth = (WIDTH - buttonSeparationX * CGFloat(numberOfButtons+1)) / CGFloat(numberOfButtons);
        var nextButtonX = CGFloat(buttonSeparationX)
        let nextButtonY = CGRectGetMaxY(msgLabel.frame)+14
        
        //in this case we only show answer and reject buttons
        if (numberOfStreams < 2) {
            let answerButton = UIButton(type: .Custom)
            answerButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40)
            let color = UIColor(red:47/255.0, green:112/255.0, blue:179/255.0, alpha:1.0)
            let backgroundImage = Bit6Utils.imageWithColor(color)
            answerButton.setBackgroundImage(backgroundImage, forState:.Normal)
            answerButton.layer.cornerRadius = 10.0
            answerButton.layer.masksToBounds = true
            answerButton.setTitle("Answer", forState:.Normal)
            let selector = callController.hasRemoteAudio ? "answerAudio" : (callController.hasRemoteVideo ? "answerVideo" : callController.hasRemoteData ? "answerData" : "") as Selector
            answerButton.addTarget(Bit6IncomingCallPrompt.sharedInstance(), action:selector, forControlEvents:.TouchUpInside)
            contentView.addSubview(answerButton)
        }
        //in this case we show two buttons
        else {
            //AUDIO BUTTON
            let audioButton = UIButton(type: .Custom)
            audioButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
            var color = UIColor(red:86/255.0, green:188/255.0, blue:221/255.0, alpha:1.0)
            var backgroundImage = Bit6Utils.imageWithColor(color)
            audioButton.setBackgroundImage(backgroundImage, forState:.Normal)
            audioButton.layer.cornerRadius = 10.0
            audioButton.layer.masksToBounds = true
            audioButton.setTitle("Audio", forState:.Normal)
            audioButton.addTarget(Bit6IncomingCallPrompt.sharedInstance(), action:"answerAudio", forControlEvents:.TouchUpInside)
            contentView.addSubview(audioButton)
            
            //VIDEO BUTTON
            if (callController.hasRemoteVideo) {
                nextButtonX = (nextButtonX + buttonWidth) + buttonSeparationX
                let videoButton = UIButton(type: .Custom)
                videoButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
                color = UIColor(red:47/255.0, green:112/255.0, blue:179/255.0, alpha:1.0)
                backgroundImage = Bit6Utils.imageWithColor(color)
                videoButton.setBackgroundImage(backgroundImage, forState:.Normal)
                videoButton.layer.cornerRadius = 10.0
                videoButton.layer.masksToBounds = true
                videoButton.setTitle("Video", forState:.Normal)
                videoButton.addTarget(Bit6IncomingCallPrompt.sharedInstance(), action:"answerVideo", forControlEvents:.TouchUpInside)
                contentView.addSubview(videoButton)
            }
        }
        
        //REJECT BUTTON
        nextButtonX = (nextButtonX + buttonWidth) + buttonSeparationX;
        let rejectButton = UIButton(type: .Custom)
        rejectButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
        let color = UIColor.yellowColor()
        let backgroundImage = Bit6Utils.imageWithColor(color)
        rejectButton.setBackgroundImage(backgroundImage, forState:.Normal)
        rejectButton.layer.cornerRadius = 10.0
        rejectButton.layer.masksToBounds = true
        
        rejectButton.setTitle("Reject", forState:.Normal)
        rejectButton.addTarget(Bit6IncomingCallPrompt.sharedInstance(), action:"reject", forControlEvents:.TouchUpInside)
        contentView.addSubview(rejectButton)
        
        return contentView;
    }

    //implement if you want to handle the entire incoming call flow
    func receivedIncomingCall(callController: Bit6CallController) {
        
        guard let msg = callController.incomingCallAlert else { return }
        
        //get the caller name
        callController.otherDisplayName = msg.stringByReplacingOccurrencesOfString(" is calling...", withString:"")
        
        callController.incomingCallAlert = "\(callController.otherDisplayName) is \(callController.hasRemoteData ? "data " : (callController.hasRemoteVideo ? "video " : ""))calling..."
        
        //register to listen changes in call status
        callController.addObserver(self, forKeyPath:"callState", options:.Old, context:nil)
        
        //the call was answered by taping the push notification
        if callController.incomingCallAnswered {
            callController.localStreams = callController.remoteStreams
            self.answerCall(callController)
        }
        else {
            //show an incoming-call prompt
            Bit6IncomingCallPrompt.sharedInstance().setContentView(self.incomingCallPromptContentViewForCallController(callController))
            
            Bit6IncomingCallPrompt.setAnswerAudioHandler({ (callController) in
                Bit6IncomingCallPrompt.dismiss()
                callController.localStreams = .Audio
                self.answerCall(callController)
            })
            Bit6IncomingCallPrompt.setAnswerVideoHandler({ (callController) in
                Bit6IncomingCallPrompt.dismiss()
                callController.localStreams = [.Audio,.Video]
                self.answerCall(callController)
            })
            Bit6IncomingCallPrompt.setRejectHandler({ (callController) in
                Bit6IncomingCallPrompt.dismiss()
                callController.removeObserver(self, forKeyPath:"callState")
                callController.declineCall()
            })

            Bit6IncomingCallPrompt.showForCallController(callController)
            
            callController.playRingtone()
        }
    }
    
   func answerCall(callController:Bit6CallController) {
        let callViewController = self.inCallViewController()
        callViewController.addCallController(callController)
        callController.start()
    
        let vc = UIApplication.sharedApplication().windows[0].rootViewController!
        if (vc.presentedViewController != nil) {
            self.presentCallViewController(callViewController)
        }
        else {
            Bit6.presentCallViewController(callViewController)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard let object = object,
              let callController = object as? Bit6CallController else { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            if keyPath == "callState" {
                self.callStateChangedNotification(callController)
            }
        }
    }

    func callStateChangedNotification(callController:Bit6CallController) {
        //the call ended: remove the observer
        if callController.callState == .MISSED || callController.callState == .END || callController.callState == .ERROR {
            callController.removeObserver(self, forKeyPath:"callState")
        }
        
        
        dispatch_async(dispatch_get_main_queue()) {
            //it's a missed call: dismiss the incoming-call prompt
            if callController.callState == .MISSED {
                Bit6IncomingCallPrompt.dismiss()
                
                let alert = UIAlertController(title:"Missed Call from \(callController.otherDisplayName)", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
            }
            //the call ended
            else if callController.callState == .END {
                //WARNING: uncomment if presented with self.presentCallViewController(callViewController)
//                self.dismissCallViewController()
            }
            //the call ended with an error
            else if callController.callState == .ERROR {
                //WARNING: uncomment if presented with self.presentCallViewController(callViewController)
//                self.dismissCallViewController()
                
                let alert = UIAlertController(title:"An Error Occurred", message:callController.error?.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
            }
        }
    }
    
    func presentCallViewController(callViewController:Bit6CallViewController) {
        //WARNING: Add your code to present the callViewController
    }
    
    func dismissCallViewController() {
        //WARNING: Add your code to dismiss the callViewController
    }
    */

    
}
