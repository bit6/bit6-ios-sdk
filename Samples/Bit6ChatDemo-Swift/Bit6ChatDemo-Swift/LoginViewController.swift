//
//  LoginViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/07/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        if Bit6.session().authenticated {
            performSegueWithIdentifier("loginCompleted", sender: self)
        }
    }
    
    @IBAction func touchedLoginBarButton(sender : UIButton) {
        let alert = UIAlertController(title:"Login", message: "Enter your username and password", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{(action :UIAlertAction) in
            let usernameTextField = alert.textFields![0]
            let passwordTextField = alert.textFields![1]
            self.login(usernameTextField.text, password: passwordTextField.text)
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Username"
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    @IBAction func touchedSignUpButton(sender : UIButton) {
        let alert = UIAlertController(title:"Login", message: "Enter an username and a password for the new account", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
            }))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{(action :UIAlertAction) in
            let usernameTextField = alert.textFields![0]
            let passwordTextField = alert.textFields![1]
            self.signUp(usernameTextField.text,password: passwordTextField.text)
            }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Username"
            })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Password"
            })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }

    func login(username:String?,password:String?){
        
        guard let username = username else {
            return
        }
        
        guard let password = password else {
            return
        }
        
        let userIdentity = Bit6Address(kind: .USERNAME, value: username)
        Bit6.session().loginWithUserIdentity(userIdentity, password: password){ (response,error) in
            if error != nil {
                let alert = UIAlertController(title:"Login Failed", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.navigationController?.presentViewController(alert, animated: true, completion:nil)
            }
            else {
                self.performSegueWithIdentifier("loginCompleted", sender: self)
            }
        }
    }
    
    func signUp(username:String?,password:String?){
        guard let username = username else {
            return
        }
        
        guard let password = password else {
            return
        }
        
        let userIdentity = Bit6Address(kind: .USERNAME, value: username)
        Bit6.session().signUpWithUserIdentity(userIdentity, password: password){ (response,error) in
            if error != nil {
                let alert = UIAlertController(title:"SignUp Failed", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.navigationController?.presentViewController(alert, animated: true, completion:nil)
            }
            else {
                self.performSegueWithIdentifier("loginCompleted", sender: self)
            }
        }
    }
    
}
