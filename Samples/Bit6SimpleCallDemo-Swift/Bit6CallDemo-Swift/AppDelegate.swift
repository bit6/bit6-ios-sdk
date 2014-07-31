//
//  AppDelegate.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/30/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: Bit6ApplicationManager, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        let apikey : NSString = YOUR_API_KEY;
        Bit6.startWithApiKey(apikey, pushNotificationMode: Bit6PushNotificationMode.DEVELOPMENT, launchingWithOptions: launchOptions);
        
        return true
    }
    
}

