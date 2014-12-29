//
//  ConversationsViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/22/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var _conversations : NSArray!
    var conversations : NSArray {
        get {
            if ((_conversations) != nil){
                return Bit6.conversations()
            }
            else {
                _conversations = Bit6.conversations()
                return _conversations
            }
        }
    }
    
    @IBOutlet var tableView:UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"conversationsUpdatedNotification:", name: Bit6ConversationsUpdatedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6ConversationsUpdatedNotification, object: nil)
    }
    
    override func viewDidLoad() {
        self.navigationItem.prompt = NSString(format: "Logged as %@", Bit6Session.userIdentity().displayName);
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func touchedLogoutBarButton(sender : UIBarButtonItem) {
        Bit6Session.logoutWithCompletionHandler({(response,error) in
            self.navigationController?.popViewControllerAnimated(true)
            NSLog("Logout")
            }
        )
    }
    
    @IBAction func touchedAddButton(sender : UIBarButtonItem) {
        var alert = UIAlertController(title:"New Conversation", message: "Type the destination username", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            var usernameTextField = alert.textFields?[0] as UITextField
            if ((usernameTextField.text as NSString).length>0){
                var address = Bit6Address(kind: Bit6AddressKind.USERNAME, value: usernameTextField.text)
                var conversation = Bit6Conversation(address: address)
                
                
                if (conversation != nil) {
                    Bit6.addConversation(conversation)
                }
                else {
                    var alert = UIAlertController(title:"Invalid username", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
                    }))
                    self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                }
                
                
            }
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
        })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath) as UITableViewCell
        
        var imageView = cell.viewWithTag(3) as Bit6ThumbnailImageView
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        var conversation = self.conversations[indexPath.row] as Bit6Conversation
        var textLabel = cell.viewWithTag(1) as UILabel
        var detailTextLabel = cell.viewWithTag(2) as UILabel
        var imageView = cell.viewWithTag(3) as Bit6ThumbnailImageView
        
        var badge = conversation.badge as NSNumber
        if (badge.integerValue != 0){
            textLabel.text = String(format: "%@ (%@)",conversation.displayName,badge)
        }
        else {
            textLabel.text = String(format: "%@",conversation.displayName)
        }
        
        var messages = conversation.messages as NSArray
        var lastMessage = messages.lastObject as Bit6Message!
        if ((lastMessage) != nil){
            detailTextLabel.text = lastMessage.content
            imageView.message = lastMessage
            imageView.hidden = !(lastMessage.type != Bit6MessageType.Text)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        if (editingStyle==UITableViewCellEditingStyle.Delete) {
            var conversation = self.conversations[indexPath.row] as Bit6Conversation
            Bit6.deleteConversation(conversation)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "showChats"){
            var ctvc = segue.destinationViewController as ChatsTableViewController
            var cell = sender as UITableViewCell
            var indexPath = self.tableView.indexPathForCell(cell)
            var conversation = self.conversations[indexPath!.row] as Bit6Conversation
            ctvc.conversation = conversation
            ctvc.title = conversation.displayName
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        
    }
    
    // MARK: - Notifications
    
    func conversationsUpdatedNotification(notification:NSNotification){
        _conversations = nil
        self.tableView.reloadData()
    }

}
