//
//  ConversationsViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/22/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var _conversations : NSMutableArray!
    var conversations : NSMutableArray {
        get {
            if ((_conversations) != nil){
                return _conversations
            }
            else {
                var conversations = Bit6.conversations()
                if (conversations != nil) {
                    _conversations = NSMutableArray(array:Bit6.conversations())
                }
                else {
                    _conversations = NSMutableArray();
                }
                return _conversations
            }
        }
    }
    
    @IBOutlet var tableView:UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"conversationsChangedNotification:", name: Bit6ConversationsChangedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        self.navigationItem.prompt = "Logged as \(Bit6.session().userIdentity.displayName)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func touchedLogoutBarButton(sender : UIBarButtonItem) {
        Bit6.session().logoutWithCompletionHandler({(response,error) in
            self.navigationController?.popViewControllerAnimated(true)
            NSLog("Logout")
            }
        )
    }
    
    @IBAction func touchedAddButton(sender : UIBarButtonItem) {
        var alert = UIAlertController(title:"New Conversation", message: "Type the destination username, or type several usernames separated by comma to create a group conversation", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(action :UIAlertAction!) in
            var usernameTextField = alert.textFields?[0] as UITextField
            if ((usernameTextField.text as NSString).length>0){
                
                var destinations =  usernameTextField.text.componentsSeparatedByString(",")
                
                if (destinations.count == 1) {
                    var address = Bit6Address(kind: .USERNAME, value: destinations[0])
                    var conversation = Bit6Conversation(address: address)
                    
                    if (conversation != nil) {
                        Bit6.addConversation(conversation)
                    }
                    else {
                        var alert = UIAlertController(title:"Invalid username", message: nil, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction!) in
                        }))
                        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                    }
                }
                else if (destinations.count>1) {
                    
                    var addresses = NSMutableArray(capacity: destinations.count)
                    
                    for (index, element) in enumerate(destinations) {
                        var address = Bit6Address(kind: .USERNAME, value: element)
                        if (address != nil) {
                            addresses.addObject(address)
                        }
                    }
                    
                    Bit6Group.createGroupWithMetadata(["title":"MyGroup"], completion: { (group, error) -> Void in
                        if (error == nil){
                            group.inviteAddresses(addresses, completion:{ (members, error) -> Void in
                                if (error != nil){
                                    var alert = UIAlertController(title:"Failed to invite users to the group", message: nil, preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction!) in
                                    }))
                                    self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                                }
                            })
                        }
                        else {
                            var alert = UIAlertController(title:"Failed to create the Group", message: nil, preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction!) in
                            }))
                            self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                        }
                    })
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
        
        var displayName = conversation.displayName
        var group = Bit6Group(forConversation:conversation)
        
        if group != nil {
            var title = group.metadata!["title"] as NSString!
            if let title = title {
                displayName = title.length > 0 ? title : conversation.displayName
            }
            else {
                displayName = conversation.displayName
            }
        }
        
        var badge = conversation.badge as NSNumber
        if (badge.integerValue != 0){
            textLabel.text = String(format: "%@ (%@)",displayName,badge)
        }
        else {
            textLabel.text = String(format: "%@",displayName)
        }
        
        var messages = conversation.messages as NSArray
        var lastMessage = messages.lastObject as Bit6Message!
        if ((lastMessage) != nil){
            detailTextLabel.text = lastMessage.content
            imageView.message = lastMessage
            imageView.hidden = !(lastMessage.type != .Text)
        }
        else {
            imageView.hidden = true
            detailTextLabel.text = ""
        }
        
        if (conversation.address.isKind(.GROUP)) {
            if (group.hasLeft) {
                detailTextLabel.text = "You have left this group"
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        if (editingStyle == .Delete) {
            var conversation = self.conversations[indexPath.row] as Bit6Conversation
            var group = Bit6Group(forConversation:conversation)
            if (group != nil && !group.hasLeft) {
                group.leaveGroupWithCompletion({ (error) -> Void in
                    if (error != nil) {
                        NSLog("Error %@",error.localizedDescription)
                    }
                })
                return
            }

            Bit6.deleteConversation(conversation, completion:nil)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> NSString
    {
        var conversation = self.conversations[indexPath.row] as Bit6Conversation
        var group = Bit6Group(forConversation:conversation)
        
        if (group != nil) {
            return group.hasLeft ? "Delete" : "Leave"
        }
        else {
            return "Delete"
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
            
            var group = Bit6Group(forConversation:conversation)
            
            if group != nil {
                var title = group.metadata!["title"] as NSString!
                if let title = title {
                    ctvc.title = title.length > 0 ? title : conversation.displayName
                }
                else {
                    ctvc.title = conversation.displayName
                }
            }
            else {
                ctvc.title = conversation.displayName
            }
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        
    }
    
    // MARK: - Data Source changes
    
    func conversationsChangedNotification(notification:NSNotification) {
        var userInfo = notification.userInfo!
        var object = userInfo[Bit6ObjectKey] as Bit6Conversation
        var change = userInfo[Bit6ChangeKey] as NSString
        
        if (change == Bit6AddedKey) {
            self.observeAddedBit6Object(object)
        }
        else if (change == Bit6UpdatedKey) {
            self.observeUpdatedBit6Object(object)
        }
        else if (change == Bit6DeletedKey) {
            self.observeDeletedBit6Object(object)
        }
    }

    func observeAddedBit6Object(conversation:Bit6Conversation) {
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.conversations.insertObject(conversation,atIndex:0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
    }
    
    func observeUpdatedBit6Object(conversation:Bit6Conversation) {
        var index = NSNotFound
        for (var x = self.conversations.count-1 ; x>=0 ; x--) {
            if (self.conversations[x].isEqual(conversation)) {
                index = x
                break
            }
        }
        
        if (index != NSNotFound) {
            var indexPath = NSIndexPath(forRow:index, inSection: 0)
            var cell = self.tableView.cellForRowAtIndexPath(indexPath)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func observeDeletedBit6Object(conversation:Bit6Conversation) {
        var index = NSNotFound
        for (var x = self.conversations.count-1 ; x>=0 ; x--) {
            if (self.conversations[x].isEqual(conversation)) {
                index = x
                break
            }
        }
        
        if (index != NSNotFound) {
            self.conversations.removeObjectAtIndex(index)
            var indexPath = NSIndexPath(forRow:index, inSection: 0)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
    }

}
