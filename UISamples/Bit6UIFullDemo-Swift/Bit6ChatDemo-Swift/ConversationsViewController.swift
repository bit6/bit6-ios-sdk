//
//  ConversationsViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/22/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import Bit6
import Bit6UI

class ConversationsViewController: BXUConversationTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bit6UI"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.Plain, target:nil, action:nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Logout", style:.Plain, target:self, action:#selector(ConversationsViewController.logout))
    }
    
    func logout() {
        Bit6.session().logoutWithCompletionHandler({(response,error) in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
            }
        )
    }
    
    @IBAction func touchedAddButton(sender : UIBarButtonItem) {
        let alert = UIAlertController(title:nil, message: "Type one username to start a direct conversation, or type several usernames separated by comma to create a group conversation", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(action :UIAlertAction) in
            let usernameTextField = alert.textFields![0]
            if usernameTextField.text?.characters.count > 0 {
                
                var usernames =  usernameTextField.text!.componentsSeparatedByString(",")
                
                //direct conversation
                if usernames.count == 1 {
                    if let address = Bit6Address(username:usernames[0]) {
                        let conversation = Bit6Conversation(address: address)
                        Bit6.addConversation(conversation)
                    }
                    else {
                        let alert = UIAlertController(title:"Invalid username", message: nil, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction) in
                        }))
                        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                    }
                }
                    
                    //group conversation
                else if usernames.count>1 {
                    
                    var addresses = [Bit6Address]()
                    for (_, element) in usernames.enumerate() {
                        if let address = Bit6Address(username:element) {
                            addresses.append(address)
                        }
                    }
                    
                    //creating the group
                    Bit6Group.createGroupWithMetadata(["title":"MyGroup"]) { (group, error) in
                        
                        //inviting the users to the group
                        if error == nil {
                            group!.inviteGroupMembersWithAddresses(addresses, role:Bit6GroupMemberRole_User) { (members, error) in
                                if error != nil {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        let alert = UIAlertController(title:"Failed to invite users to the group", message: nil, preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                                        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                                    }
                                }
                            }
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue()) {
                                let alert = UIAlertController(title:"Failed to create the Group", message: nil, preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                                self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                            }
                        }
                    }
                }
            }
        }))
        alert.addTextFieldWithConfigurationHandler(nil)
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    // MARK: - Navigation
    
    override func didSelectConversation(conversation: Bit6Conversation!) {
        self.performSegueWithIdentifier("showConversation", sender:conversation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showConversation" {
            let ctvc = segue.destinationViewController as! ChatsTableViewController
            let conversation = sender as! Bit6Conversation
            ctvc.address = conversation.address
        }
    }
}