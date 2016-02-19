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
    
    var showingCallObserver : AnyObject?;
    var dismissingCallObserver : AnyObject?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        showingCallObserver = NSNotificationCenter.defaultCenter().addObserverForName("SHOW_CALL", object:nil, queue:nil) { (note) in
            let callViewController = note.object as! Bit6CallViewController;
            self.presentCallViewController(callViewController)
        }
        dismissingCallObserver = NSNotificationCenter.defaultCenter().addObserverForName("DISMISS_CALL", object:nil, queue:nil) { (note) in
            self.dismissCallViewController()
        }
    }
    
    deinit {
        if let observer = showingCallObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        if let observer = dismissingCallObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
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
            let vc = UIApplication.sharedApplication().windows[0].rootViewController!
            if (vc.presentedViewController != nil) {
                callController.addObserver(self, forKeyPath:"callState", options:.Old, context:nil)
                self.presentCallViewController(callViewController)
            }
            else {
                Bit6.presentCallViewController(callViewController)
            }
        }
        else {
            NSLog("Call Failed")
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard let object = object,
            let callController = object as? Bit6CallController else { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            if keyPath == "callState" {
                self.callStateChangedNotification(callController)
            }
        }
    }
    
    func callStateChangedNotification(callController:Bit6CallController) {
        if callController.callState == .END || callController.callState == .ERROR {
            callController.removeObserver(self, forKeyPath:"callState")
            self.dismissCallViewController()
        }
    }
    
    func presentCallViewController(callViewController:Bit6CallViewController) {
        self.presentViewController(callViewController, animated:true, completion:nil)
    }
    
    func dismissCallViewController() {
        self.dismissViewControllerAnimated(true, completion:nil)
    }

}
