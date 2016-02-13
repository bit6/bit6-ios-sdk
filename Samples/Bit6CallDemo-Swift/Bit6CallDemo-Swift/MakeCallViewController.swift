//
//  MakeCallViewController.swift
//  Bit6CallDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/30/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import Bit6

class MakeCallViewController: UIViewController {

    @IBOutlet var destinationUsernameTextField:UITextField!
    @IBOutlet var phoneNumberTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userIdentity = Bit6.session().activeIdentity {
            self.navigationItem.prompt = "Logged as \(userIdentity.displayName)"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userIdentity = Bit6.session().activeIdentity {
            self.navigationItem.prompt = "Logged as \(userIdentity.displayName)"
        }
    }
    
    @IBAction func touchedLogoutBarButton(sender: UIButton) {
        Bit6.session().logoutWithCompletionHandler{ (response,error) in
            if error != nil {
                self.navigationController?.popViewControllerAnimated(true)
                NSLog("Logout")
            }
        }
    }
    
    @IBAction func touchedAudioCallButton(sender : UIButton) {
        if let username = self.destinationUsernameTextField.text {
            if let address = Bit6Address(username:username) {
                let callController = Bit6.createCallTo(address, streams:.Audio)
                self.startCallToCalController(callController)
            }
        }
    }
    
    @IBAction func touchedVideoCallButton(sender : UIButton) {
        if let username = self.destinationUsernameTextField.text {
            if let address = Bit6Address(username:username) {
                let callController = Bit6.createCallTo(address, streams:[.Audio,.Video])
                self.startCallToCalController(callController)
            }
        }
    }
    
    @IBAction func touchedDialButton(sender : UIButton) {
        if let phoneNumber = self.phoneNumberTextField.text {
            let callController = Bit6.createCallToPhoneNumber(phoneNumber)
            self.startCallToCalController(callController)
        }
    }
    
    func startCallToCalController(callController:Bit6CallController!){
        
        if callController != nil {
            //trying to reuse the previous viewController, or create a default one
            let callViewController = Bit6.callViewController() ?? Bit6CallViewController.createDefaultCallViewController()
            
            //trying to reuse the previous viewController, or create a custom one
            //let callViewController = Bit6.callViewController() ?? MyCallViewController()
            
            //set the call to the viewController
            callViewController.addCallController(callController)
            
            //start the call
            callController.start()
            
            //present the viewController
            Bit6.presentCallViewController(callViewController)
        }
        else {
            NSLog("Call Failed")
        }
    }

}
