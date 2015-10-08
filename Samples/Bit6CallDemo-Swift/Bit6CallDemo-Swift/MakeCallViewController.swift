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
    @IBOutlet var phoneNumberTextField:UITextField!
    
    override func viewDidLoad() {
        self.navigationItem.prompt = "Logged as \(Bit6.session().userIdentity.displayName)"
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
        let username = self.destinationUsernameTextField.text
        let address = Bit6Address(kind: .USERNAME, value:username)
        
        let callController = Bit6.startCallToAddress(address, hasAudio:true, hasVideo:false, hasData:false)
        self.startCallToCalController(callController)
    }
    
    @IBAction func touchedVideoCallButton(sender : UIButton) {
        let username = self.destinationUsernameTextField.text
        let address = Bit6Address(kind: .USERNAME, value:username)
        
        let callController = Bit6.startCallToAddress(address, hasAudio:true, hasVideo:true, hasData:false)
        self.startCallToCalController(callController)
    }
    
    @IBAction func touchedDialButton(sender : UIButton) {
        let phoneNumber = self.phoneNumberTextField.text
        
        let callController = Bit6.startCallToPhoneNumber(phoneNumber)
        self.startCallToCalController(callController)
    }
    
    func startCallToCalController(callController:Bit6CallController!){
        if callController != nil {
            //we listen to call state changes
            callController.addObserver(self, forKeyPath:"callState", options: .Old, context:nil)
            
            //create the default in-call UIViewController
            let callVC = Bit6CallViewController.createDefaultCallViewController()
            
            //use a custom in-call UIViewController
            //var callVC = MyCallViewController()
            
            //start the call
            callController.connectToViewController(callVC)
        }
        else {
            NSLog("Call Failed")
        }
    }
    
    // MARK: - CALLS
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        dispatch_async(dispatch_get_main_queue()) {
            if object!.isKindOfClass(Bit6CallController) {
                if keyPath == "callState" {
                    self.callStateChangedNotification(object as! Bit6CallController)
                }
            }
        }
    }
    
    func callStateChangedNotification(callController:Bit6CallController) {
        dispatch_async(dispatch_get_main_queue()) {
            //the call is starting: show the viewController
            if callController.callState == .PROGRESS {
                Bit6.presentCallViewController()
            }
                //the call ended: remove the observer and dismiss the viewController
            else if callController.callState == .END {
                callController.removeObserver(self, forKeyPath:"callState")
            }
                //the call ended with an error: remove the observer and dismiss the viewController
            else if callController.callState == .ERROR {
                callController.removeObserver(self, forKeyPath:"callState")
                
                let alert = UIAlertController(title:"An Error Occurred", message: callController.error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.view.window?.rootViewController?.presentViewController(alert, animated: true, completion:nil)
            }
        }
    }

}
