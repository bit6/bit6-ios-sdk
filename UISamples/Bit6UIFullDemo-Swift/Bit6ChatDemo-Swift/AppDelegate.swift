//
//  AppDelegate.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/22/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import Bit6
import Bit6UI

//WARNING: Remember to set your api key
let BIT6_API_KEY = "BIT6_API_KEY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        assert(BIT6_API_KEY != "BIT6_API_KEY", "[Bit6 SDK]: Setup your Bit6 api key.")
        
        NSNotificationCenter.defaultCenter().addObserverForName(Bit6LogoutCompletedNotification, object:nil, queue:nil) { (note) in
            if let error = note.userInfo?[Bit6ErrorKey] as? NSNumber {
                if error.integerValue == NSURLErrorUserCancelledAuthentication {
                    dispatch_async(dispatch_get_main_queue()) {
                        Bit6AlertView.showAlertControllerWithTitle("Invalid Session", message:"Please login again", cancelButtonTitle:"OK")
                    }
                }
            }
        }
        
        //WARNING: change to Bit6CallMediaModeMix to enable recording during a call
        BXU.setCallMediaMode(Bit6CallMediaModeP2P)
        
        //WARNING: change to CustomCallViewController and play with source files to change the UI
        Bit6.setInCallClass(BXUCallViewController)
        
        //prepare for incoming messages
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.incomingMessageNotification(_:)), name:Bit6IncomingMessageNotification, object:nil)
        
        //prepare to receive incoming calls
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.incomingCallNotification(_:)), name:Bit6IncomingCallNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.callAddedNotification(_:)), name:Bit6CallAddedNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.callPermissionsMissingNotification(_:)), name:Bit6CallPermissionsMissingNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.callMissedNotification(_:)), name:Bit6CallMissedNotification, object:nil)
        
        //starting Bit6 SDK
        Bit6.startWithApiKey(BIT6_API_KEY)
        
        return true
    }
    
    // MARK: - Notifications
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Bit6.pushNotification().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Bit6.pushNotification().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        Bit6.pushNotification().didReceiveNotificationUserInfo(userInfo)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        Bit6.pushNotification().didReceiveNotificationUserInfo(userInfo, fetchCompletionHandler: completionHandler)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forNotificationUserInfo: userInfo, completionHandler: completionHandler)
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forNotificationUserInfo: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        Bit6.pushNotification().didReceiveNotificationUserInfo(notification.userInfo!)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forNotificationUserInfo: notification.userInfo!, completionHandler: completionHandler)
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forNotificationUserInfo: notification.userInfo!, withResponseInfo: responseInfo, completionHandler: completionHandler)
    }
    
    // MARK: - Call Listener
    
    var callController : Bit6CallController?
    
    func incomingCallNotification(notification:NSNotification)
    {
        let callController = notification.object as! Bit6CallController
        
        //there's a call prompt showing at the time
        if let incomingCallPromptCallController = BXUIncomingCallPrompt.callController() {
            
            //if this is not the same call as the one being shown for Bit6IncomingCallPrompt then we reject it
            if incomingCallPromptCallController != callController {
                callController.hangup()
            }
        }
        else {
            //the call was answered by taping the push notification
            if callController.answered {
                callController.remoteStreams = BXU.availableStreamsIn(callController.availableStreamsForIncomingCall)
                callController.localStreams = BXU.availableStreamsIn(callController.availableStreamsForIncomingCall)
                callController.mediaMode = BXU.callMediaMode()
                callController.start()
            }
            else {
                BXUIncomingCallPrompt.showForCallController(callController)
            }
        }
    }
    
    //ready to start the call, lets show the UI
    func callAddedNotification(notification:NSNotification)
    {
        let callController = notification.object as! Bit6CallController
        let callViewController = Bit6.createViewControllerForCall(callController)!
        callViewController.show()
    }
    
    //there's restricted access to microphone or camera
    func callPermissionsMissingNotification(notification:NSNotification)
    {
        let callController = notification.object as! Bit6CallController
        let error = callController.error!
        Bit6AlertView.showAlertControllerWithTitle(error.localizedDescription, message:nil, cancelButtonTitle:"OK")
    }
    
    //missed call
    func callMissedNotification(notification:NSNotification)
    {
        let appState = UIApplication.sharedApplication().applicationState
        if appState == .Active {
            let callController = notification.object as! Bit6CallController
            if self.callController == callController {
                self.callController = nil
                self.window?.rootViewController?.dismissViewControllerAnimated(true, completion:nil)
            }
            
            let title = "Missed Call from \(BXU.displayNameForAddress(callController.other))"
            Bit6AlertView.showAlertControllerWithTitle(title, message:nil, cancelButtonTitle:"OK")
        }
    }
    
    // MARK: - Message Listener
    
    func incomingMessageNotification(notification:NSNotification)
    {
        let appState = UIApplication.sharedApplication().applicationState
        let address = notification.userInfo![Bit6AddressKey] as! Bit6Address
        let tapped = notification.userInfo![Bit6TappedKey] as! Bool
        let message = notification.userInfo![Bit6MessageKey] as! String
        
        //the user is not inside the conversation
        if Bit6.currentConversation()?.address != address {
            //the user tapped the notification
            if tapped {
               NSNotificationCenter.defaultCenter().postNotificationName(BXUConversationSelectedNotification, object:address)
            }
            //we were inside the app when the notification arrived, we show the banner
            else {
                if appState != .Background {
                    BXU.showNotificationFrom(address, message:message, tappedHandler:nil)
                }
            }
        }
    }

}

