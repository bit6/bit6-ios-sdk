//
//  ConversationsViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/22/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import Bit6

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var _conversations : NSMutableArray!
    var conversations : NSMutableArray {
        get {
            if _conversations != nil {
                return _conversations
            }
            else {
                let conversations = Bit6.conversations()
                if conversations != nil {
                    if let conversationsArray = Bit6.conversations() {
                        _conversations = NSMutableArray(array:conversationsArray)
                    }
                    else {
                        _conversations = NSMutableArray()
                    }
                }
                else {
                    _conversations = NSMutableArray();
                }
                return _conversations
            }
        }
    }
    
    @IBOutlet var tableView:UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"conversationsChangedNotification:", name: Bit6ConversationsChangedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        if let userIdentity = Bit6.session().activeIdentity {
            self.navigationItem.prompt = "Logged as \(userIdentity.displayName)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func touchedLogoutBarButton(sender : UIBarButtonItem) {
        Bit6.session().logoutWithCompletionHandler({(response,error) in
            if error != nil {
                self.navigationController?.popViewControllerAnimated(true)
                NSLog("Logout")
            }
            }
        )
    }
    
    @IBAction func touchedAddButton(sender : UIBarButtonItem) {
        let alert = UIAlertController(title:"New Conversation", message: "Type the destination username, or type several usernames separated by comma to create a group conversation", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(action :UIAlertAction) in
            let usernameTextField = alert.textFields![0]
            if usernameTextField.text?.characters.count > 0 {
                
                var destinations =  usernameTextField.text!.componentsSeparatedByString(",")
                
                if destinations.count == 1 {
                    if let address = Bit6Address(username:destinations[0]) {
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
                else if destinations.count>1 {
                    
                    var addresses = [Bit6Address]()
                    var roles = [String]()
                    
                    for (_, element) in destinations.enumerate() {
                        if let address = Bit6Address(username:element) {
                            addresses.append(address)
                            roles.append(Bit6GroupMemberRole_User)
                        }
                    }
                    
                    Bit6Group.createGroupWithMetadata(["title":"MyGroup"]) { (group, error) in
                        if error == nil {
                            group!.inviteGroupMembersWithAddresses(addresses, roles:roles) { (members, error) in
                                if error != nil {
                                    let alert = UIAlertController(title:"Failed to invite users to the group", message: nil, preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                                    self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                                }
                            }
                        }
                        else {
                            let alert = UIAlertController(title:"Failed to create the Group", message: nil, preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                            self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                        }
                    }
                }
            }
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Username"
        })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath) 
        
        let imageView = cell.viewWithTag(3) as! Bit6ThumbnailImageView
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let conversation = self.conversations[indexPath.row] as! Bit6Conversation
        let textLabel = cell.viewWithTag(1) as! UILabel
        let detailTextLabel = cell.viewWithTag(2) as! UILabel
        let imageView = cell.viewWithTag(3) as! Bit6ThumbnailImageView
        
        var displayName = conversation.address.displayName
        
        let badge = conversation.badge as NSNumber
        if badge.integerValue != 0 {
            textLabel.text = "\(displayName) (\(badge))"
        }
        else {
            textLabel.text = displayName
        }
        
        let messages = conversation.messages as NSArray
        if let lastMessage = messages.lastObject as? Bit6Message {
            detailTextLabel.text = lastMessage.content
            imageView.message = lastMessage
            imageView.hidden = !(lastMessage.type != .Text)
        }
        else {
            imageView.hidden = true
            detailTextLabel.text = ""
        }
        
        if let group = Bit6Group(conversation:conversation) {
            let title = group.metadata!["title"] as! String!
            if let title = title {
                displayName = title.characters.count > 0 ? title : conversation.address.displayName
            }
            else {
                displayName = conversation.address.displayName
            }
            
            if group.hasLeft {
                detailTextLabel.text = "You have left this group"
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete {
            let conversation = self.conversations[indexPath.row] as! Bit6Conversation
            if let group = Bit6Group(conversation:conversation) {
                if !group.hasLeft {
                    group.leaveGroupWithCompletion{ (error)  in
                        if let error = error {
                            NSLog("Error \(error.localizedDescription)")
                        }
                    }
                }
                return
            }

            Bit6.deleteConversation(conversation, completion:nil)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let conversation = self.conversations[indexPath.row] as! Bit6Conversation

        if let group = Bit6Group(conversation:conversation) {
            return group.hasLeft ? "Delete" : "Leave"
        }
        else {
            return "Delete"
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showChats" {
            let ctvc = segue.destinationViewController as! ChatsTableViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)
            let conversation = self.conversations[indexPath!.row] as! Bit6Conversation
            ctvc.conversation = conversation
            
            if let group = Bit6Group(conversation:conversation) {
                let title = group.metadata!["title"] as! String!
                if let title = title {
                    ctvc.title = title.characters.count > 0 ? title : conversation.address.displayName
                }
                else {
                    ctvc.title = conversation.address.displayName
                }
            }
            else {
                ctvc.title = conversation.address.displayName
            }
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        
    }
    
    // MARK: - Data Source changes
    
    func conversationsChangedNotification(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let object = userInfo[Bit6ObjectKey] as! Bit6Conversation
        let change = userInfo[Bit6ChangeKey] as! NSString
        
        if change == Bit6AddedKey {
            self.observeAddedBit6Object(object)
        }
        else if change == Bit6UpdatedKey {
            self.observeUpdatedBit6Object(object)
        }
        else if change == Bit6DeletedKey {
            self.observeDeletedBit6Object(object)
        }
    }

    func observeAddedBit6Object(conversation:Bit6Conversation) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.conversations.insertObject(conversation,atIndex:0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
    }
    
    func observeUpdatedBit6Object(conversation:Bit6Conversation) {
        var index = NSNotFound
        for var x = self.conversations.count-1 ; x>=0 ; x-- {
            if self.conversations[x].isEqual(conversation) {
                index = x
                break
            }
        }
        
        if index != NSNotFound {
            let indexPath = NSIndexPath(forRow:index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func observeDeletedBit6Object(conversation:Bit6Conversation) {
        var index = NSNotFound
        for var x = self.conversations.count-1 ; x>=0 ; x-- {
            if self.conversations[x].isEqual(conversation) {
                index = x
                break
            }
        }
        
        if index != NSNotFound {
            self.conversations.removeObjectAtIndex(index)
            let indexPath = NSIndexPath(forRow:index, inSection: 0)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
    }

}
