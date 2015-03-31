//
//  AppDelegate.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/22/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: Bit6ApplicationManager, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let apikey : NSString = "your_api_key";
        Bit6.startWithApiKey(apikey, pushNotificationMode: .DEVELOPMENT, launchingWithOptions: launchOptions);
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        super.didReceiveRemoteNotification(userInfo, fetchCompletionHandler:completionHandler);
    }

}
