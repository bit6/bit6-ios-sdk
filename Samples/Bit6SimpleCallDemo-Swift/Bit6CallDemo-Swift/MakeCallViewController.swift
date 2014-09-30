//
//  MakeCallViewController.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/30/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

class MakeCallViewController: UIViewController {

    @IBOutlet var destinationUsernameTextField:UITextField!
    
    override func viewDidLoad() {
        self.navigationItem.prompt = NSString(format: "Logged as %@", Bit6Session.userIdentity().displayName);
    }
    
    @IBAction func touchedLogoutBarButton(sender : UIButton) {
        Bit6Session.logoutWithCompletionHandler({(response,error) in
            self.navigationController?.popViewControllerAnimated(true)
            NSLog("Logout")
            }
        )
    }
    
    @IBAction func touchedAudioCallButton(sender : UIButton) {
        var username : NSString = self.destinationUsernameTextField.text;
        if (username.length>0){
            var address = Bit6Address(kind: Bit6AddressKind.USERNAME, value:username)
            Bit6.startCallToAddress(address, hasVideo: false);
        }
    }
    
    @IBAction func touchedVideoCallButton(sender : UIButton) {
        var username : NSString = self.destinationUsernameTextField.text;
        if (username.length>0){
            var address = Bit6Address(kind: Bit6AddressKind.USERNAME, value:username)
            Bit6.startCallToAddress(address, hasVideo: true);
        }
    }
}
