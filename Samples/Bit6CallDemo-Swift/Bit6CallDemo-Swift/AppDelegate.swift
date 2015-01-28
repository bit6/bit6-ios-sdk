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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedIncomingCallNotification:", name: Bit6IncomingCallNotification, object: nil)
        
        let apikey : NSString = "your_api_key";
        Bit6.startWithApiKey(apikey, pushNotificationMode: Bit6PushNotificationMode.DEVELOPMENT, launchingWithOptions: launchOptions);
        
        //set this if you want customize the controls overlay in the inCall screen
//        Bit6InCallController.sharedInstance().delegate = self;
        
        return true
    }
    
    func receivedIncomingCallNotification(notification:NSNotification) -> Void {
        
        var callController = Bit6.callControllerFromIncomingCallNotification(notification)
        
        if (Bit6.currentCallController() != nil) {
            //there's a call on the way
            callController.declineCall();
        }
        else {
            var type = callController.hasVideo ?"Video":"Audio";
            var message = "Incoming \(type) Call: \(callController.other)"
            
            if (UIApplication.sharedApplication().applicationState == UIApplicationState.Active){
                callController.startRingtone()

                var message = "Incoming \(type) Call: \(callController.other)"
                var alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
                    callController.declineCall();
                }))
                alert.addAction(UIAlertAction(title: "Answer", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
                    self.answerCall(callController)
                }))
                
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
            }
        }
    }
    
    func answerCall(callController:Bit6CallController!) -> Void {
        
        if let _callController = callController {
            //Default ViewController
            callController.connectToViewController(nil, completion:{(viewController : UIViewController!, error : NSError!) in
                if (error != nil){
                    NSLog("Call Failed");
                }
                else {
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "callStateChangedNotification:", name: Bit6CallStateChangedNotification, object: callController)
                    UIApplication.sharedApplication().windows[0].rootViewController!?.presentViewController(viewController, animated: true, completion: nil)
                }
            })
            
            //Custom ViewController
            /*
            var vc = MyCallViewController(callController:_callController)
            _callController.connectToViewController(vc, completion:{(viewController : UIViewController!, error : NSError!) in
                if (error != nil){
                    NSLog("Call Failed");
                }
                else {
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "callStateChangedNotification:", name: Bit6CallStateChangedNotification, object: callController)
                    UIApplication.sharedApplication().windows[0].rootViewController!?.presentViewController(viewController, animated: true, completion: nil)
                }
            })
            */
        }
    }
    
    func callStateChangedNotification(notification:NSNotification) -> Void {
        var callController = notification.object as Bit6CallController
        
        if (callController.callState == Bit6CallState.END || callController.callState == Bit6CallState.ERROR) {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6CallStateChangedNotification, object: callController)
            
            dispatch_async(dispatch_get_main_queue()) {
                if let vc = UIApplication.sharedApplication().windows[0].rootViewController! {
                    vc.dismissViewControllerAnimated(true, completion: nil)
                }
                if (callController.callState == Bit6CallState.ERROR){
                    NSLog("An Error Occurred");
                }
            }
        }
    }
    
}

