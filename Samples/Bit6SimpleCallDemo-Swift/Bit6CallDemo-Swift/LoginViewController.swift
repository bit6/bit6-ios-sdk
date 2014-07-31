//
//  LoginViewController.swift
//  FullDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/07/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        if (Bit6Session.isConnected()) {
            performSegueWithIdentifier("loginCompleted", sender: self)
        }
    }
    
    @IBAction func touchedLoginBarButton(sender : UIButton) {
        var alert = UIAlertController(title:"Login", message: "Enter your username and password", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            var usernameTextField = alert.textFields[0] as UITextField
            var passwordTextField = alert.textFields[1] as UITextField
            self.login(usernameTextField.text,password: passwordTextField.text)
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        self.navigationController.presentViewController(alert, animated: true, completion:nil)
    }
    
    @IBAction func touchedSignUpButton(sender : UIButton) {
        var alert = UIAlertController(title:"Login", message: "Enter an username and a password for the new account", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            
            }))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            var usernameTextField = alert.textFields[0] as UITextField
            var passwordTextField = alert.textFields[1] as UITextField
            self.signUp(usernameTextField.text,password: passwordTextField.text)
            }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
            })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Password"
            })
        
        self.navigationController.presentViewController(alert, animated: true, completion:nil)
    }

    func login(username:String,password:String){
        var userIdentity = Bit6Address(kind: Bit6AddressKind.USERNAME, value: username)
        Bit6Session.loginWithUserIdentity(userIdentity, password: password, completionHandler:{(response,error) in
            if (error){
                var alert = UIAlertController(title:"Login Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
                self.navigationController.presentViewController(alert, animated: true, completion:nil)
            }
            else {
                self.performSegueWithIdentifier("loginCompleted", sender: self)
            }
            })
    }
    
    func signUp(username:String,password:String){
        var userIdentity = Bit6Address(kind: Bit6AddressKind.USERNAME, value: username)
        Bit6Session.signUpWithUserIdentity(userIdentity, password: password, completionHandler:{(response,error) in
            if (error){
                var alert = UIAlertController(title:"SignUp Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
                self.navigationController.presentViewController(alert, animated: true, completion:nil)
            }
            else {
                self.performSegueWithIdentifier("loginCompleted", sender: self)
            }
            })
    }
    
}
