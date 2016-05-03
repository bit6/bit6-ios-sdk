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
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        Bit6.pushNotification().handleActionWithIdentifier(identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        Bit6.pushNotification().didReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Bit6.pushNotification().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Bit6.pushNotification().didFailToRegisterForRemoteNotificationsWithError(error)
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
                callController.decline()
            }
        }
        else {
            //the call was answered by taping the push notification
            if callController.answered {
                callController.localStreams = callController.remoteStreams
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
        let error = notification.userInfo![Bit6ErrorKey] as! NSError
        let alertView = UIAlertController(title:error.localizedDescription, message:nil, preferredStyle:.Alert)
        alertView.addAction(UIAlertAction(title:"OK", style:.Cancel, handler:nil))
        self.window?.rootViewController?.presentViewController(alertView, animated:true, completion:nil)
    }
    
    //missed call
    func callMissedNotification(notification:NSNotification)
    {
        let callController = notification.object as! Bit6CallController
        if self.callController == callController {
            self.callController = nil
            self.window?.rootViewController?.dismissViewControllerAnimated(true, completion:nil)
        }
        
        let title = "Missed Call from \(callController.other.value)"
        let alertView = UIAlertController(title:title, message:nil, preferredStyle:.Alert)
        alertView.addAction(UIAlertAction(title:"OK", style:.Cancel, handler:nil))
        self.window?.rootViewController?.presentViewController(alertView, animated:true, completion:nil)
    }
    
    // MARK: - Message Listener
    
    func incomingMessageNotification(notification:NSNotification)
    {
        let appState = UIApplication.sharedApplication().applicationState
        
        let address = notification.userInfo![Bit6AddressKey] as! Bit6Address
        let message = notification.userInfo![Bit6MessageKey] as! String
        
        //notification not tapped
        if appState == .Active {
            //the user is not inside the conversation
            if Bit6.currentConversation()?.address != address {
                //showing the banner
                BXU.showNotificationFrom(address, message:message, tappedHandler:nil)
            }
        }
            
        //notification tapped
        else if appState == .Inactive {
            NSNotificationCenter.defaultCenter().postNotificationName(BXUConversationSelectedNotification, object:address)
        }
    }

}

