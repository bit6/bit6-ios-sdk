//
//  AppDelegate.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/30/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: Bit6ApplicationManager, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var incomingCallPrompt : UIAlertController?
    var callController: Bit6CallController?
    var showingCallViewController: Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        let apikey : NSString = "your_api_key";
        Bit6.startWithApiKey(apikey, pushNotificationMode: .DEVELOPMENT, launchingWithOptions: launchOptions)
        
        return true
    }
    
    // MARK: - Calls
    
    /*
    //use a custom in-call UIViewController
    override func inCallViewController() -> Bit6CallViewController
    {
        var callVC = MyCallViewController()
        return callVC
    }
    */
    
    /*
    //customize in-app incoming call banner notification
    override func incomingCallNotificationBannerContentView() -> UIView
    {
        var numberOfLinesInMSG = 1
        var padding = CGFloat(10.0)
        var separation = CGFloat(3.0)
        var titleHeight = CGFloat(19.0)
        var messageHeight = CGFloat(17*numberOfLinesInMSG+5*(numberOfLinesInMSG-1))
        var buttonsAreaHeight = CGFloat(60.0)
        var height = padding*2+titleHeight+separation+messageHeight+buttonsAreaHeight
        
        var frame = UIScreen.mainScreen().bounds
        frame.size.height = height
        
        var deviceType = UIDevice.currentDevice().model as NSString
        
        if (deviceType.hasPrefix("iPad")) {
            var width = 450.0 as CGFloat
            frame.origin.x = (frame.size.width-width)/2.0;
            frame.size.width = width;
        }
        
        var contentView = UIView(frame: frame)
        contentView.backgroundColor = UIColor(red: 47/255.0, green: 49/255.0, blue: 50/255.0, alpha: 1.0)
        
        var titleLabel = UILabel(frame: CGRectMake(padding, padding, frame.size.width - padding*2, titleHeight))
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.tag = 15
        contentView.addSubview(titleLabel)
        
        var msgLabel = UILabel(frame: CGRectMake(padding, CGRectGetMaxY(titleLabel.frame)+separation, frame.size.width - padding*2, messageHeight))
        msgLabel.font = UIFont.systemFontOfSize(15.0)
        msgLabel.textColor = UIColor.whiteColor()
        msgLabel.tag = 16;
        msgLabel.numberOfLines = numberOfLinesInMSG;
        contentView.addSubview(msgLabel)
        
        var button1 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button1.tag = 17
        button1.frame = CGRectMake(padding, CGRectGetMaxY(msgLabel.frame)+padding+6, (contentView.frame.size.width-padding*3)/2, buttonsAreaHeight-padding*2);
        button1.setBackgroundImage(Bit6Utils.imageWithColor(UIColor.redColor()), forState:.Normal)
        button1.layer.cornerRadius = 10.0
        button1.clipsToBounds = true
        button1.setTitle("Decline", forState: .Normal)
        contentView.addSubview(button1)
        
        var button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.tag = 18;
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame)+padding, CGRectGetMaxY(msgLabel.frame)+padding+6, (contentView.frame.size.width-padding*3)/2, buttonsAreaHeight-padding*2)
        button2.setBackgroundImage(Bit6Utils.imageWithColor(UIColor.blueColor()), forState:.Normal)
        button1.layer.cornerRadius = 10.0
        button1.clipsToBounds = true
        button1.setTitle("Answer", forState: .Normal)
        contentView.addSubview(button2)
        
        return contentView;
    }
    */

    
    // MARK: - Handling Call Full Flow

    /*
    override func receivedIncomingCallNotification(notification:NSNotification) {
        //create the callController
        var callController = Bit6.callControllerFromIncomingCallNotification(notification)
        
        //if there's a call on the way we decline this one
        if (Bit6.currentCallController() != nil || self.callController != nil) {
            callController.declineCall()
        }
        else {
            //register to listen changes in call status
            callController.addObserver(self, forKeyPath:"callState", options: .Old, context:nil)
            
            //get the caller name
            var msg = callController.incomingCallAlert
            callController.otherDisplayName = msg.stringByReplacingOccurrencesOfString(" is calling...", withString:"")
            
            //get the call type
            var type = callController.hasVideo ?"Video":"Audio"
            
            //show an incoming-call prompt
            var message = "Incoming \(type) Call\n\(callController.otherDisplayName)"
            callController.incomingCallAlert = message
            
            //the call was answered by taping the push notification
            if (callController.incomingCallAnswered) {
                self.answerCall(callController)
            }
            else {
                //retain the callController while we show an incoming-call prompt
                self.callController = callController
                
                //show an incoming-call prompt
                Bit6.incomingCallNotificationBanner().showBannerForCallController(callController, answerHandler:{() in
                        var callController = self.callController
                        self.callController = nil
                        self.answerCall(callController!)
                    }, declineHandler:{() in
                        var callController = self.callController
                        self.callController = nil
                        callController!.removeObserver(self, forKeyPath:"callState")
                        callController!.declineCall()
                })
                
                //play the ringtone
                callController.startRingtone()
            }
        }
    }
    
    func answerCall(callController:Bit6CallController) {
        //create the in-call UIViewController
        var callVC = self.inCallViewController()
        
        //start the call
        callController.connectToViewController(callVC)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        dispatch_async(dispatch_get_main_queue()) {
            if (object.isKindOfClass(Bit6CallController)) {
                if (keyPath == "callState") {
                    self.callStateChangedNotification(object as Bit6CallController)
                }
            }
        }
    }

    func callStateChangedNotification(callController:Bit6CallController) {
        dispatch_async(dispatch_get_main_queue()) {
            //it's a missed call: remove the observer, dismiss the incoming-call prompt and the viewController
            if (callController.callState == .MISSED) {
                callController.removeObserver(self, forKeyPath:"callState")
                self.callController = nil
                Bit6.incomingCallNotificationBanner().dismiss()
                Bit6.dismissCallController(callController)
                
                var alert = UIAlertController(title:"Missed Call from \(callController.otherDisplayName)", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
            }
            //the call is starting: show the viewController
            else if (callController.callState == .PROGRESS) {
                Bit6.presentCallController(callController)
            }
            //the call ended: remove the observer and dismiss the viewController
            else if (callController.callState == .END) {
                callController.removeObserver(self, forKeyPath:"callState")
                Bit6.dismissCallController(callController)
            }
            //the call ended with an error: remove the observer and dismiss the viewController
            else if (callController.callState == .ERROR) {
                callController.removeObserver(self, forKeyPath:"callState")
                Bit6.dismissCallController(callController)
                
                var alert = UIAlertController(title:"An Error Occurred", message: callController.error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
            }
        }
    }
    */
    
}

