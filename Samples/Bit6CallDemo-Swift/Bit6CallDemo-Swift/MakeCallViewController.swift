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
        self.navigationItem.prompt = NSString(format: "Logged as %@", Bit6.session().userIdentity.displayName);
    }
    
    @IBAction func touchedLogoutBarButton(sender: UIButton) {
        Bit6.session().logoutWithCompletionHandler({(response,error) in
            self.navigationController?.popViewControllerAnimated(true)
            NSLog("Logout")
            }
        )
    }
    
    @IBAction func touchedAudioCallButton(sender : UIButton) {
        var username : NSString = self.destinationUsernameTextField.text;
        var address = Bit6Address(kind: Bit6AddressKind.USERNAME, value:username)
        
        var callController = Bit6.startCallToAddress(address, hasVideo:false)
        self.startCallToCalController(callController)
    }
    
    @IBAction func touchedVideoCallButton(sender : UIButton) {
        var username : NSString = self.destinationUsernameTextField.text;
        var address = Bit6Address(kind: Bit6AddressKind.USERNAME, value:username)
        
        var callController = Bit6.startCallToAddress(address, hasVideo:true)
        self.startCallToCalController(callController)
    }
    
    @IBAction func touchedDialButton(sender : UIButton) {
        var phoneNumber : NSString = self.phoneNumberTextField.text;
        
        var callController = Bit6.startCallToPhoneNumber(phoneNumber)
        self.startCallToCalController(callController)
    }
    
    func startCallToCalController(callController:Bit6CallController!){
        if (callController != nil){
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
        }
        else {
            NSLog("Call Failed");
        }
        
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
    
    // MARK: - CALLS
    
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
