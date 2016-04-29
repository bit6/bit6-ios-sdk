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

    var _conversations : [Bit6Conversation]!
    var conversations : [Bit6Conversation] {
        get {
            if _conversations != nil {
                return _conversations
            }
            else {
                let conversations = Bit6.conversations()
                if conversations != nil {
                    if let conversationsArray = Bit6.conversations() {
                        _conversations = conversationsArray
                    }
                    else {
                        _conversations = [Bit6Conversation]()
                    }
                }
                else {
                    _conversations = [Bit6Conversation]()
                }
                return _conversations
            }
        }
        set {
            _conversations = newValue
        }
    }
    
    @IBOutlet var tableView:UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ConversationsViewController.conversationsChangedNotification(_:)), name: Bit6ConversationsChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ConversationsViewController.groupsChangedNotification(_:)), name: Bit6GroupsChangedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        if let userIdentity = Bit6.session().activeIdentity {
            self.navigationItem.prompt = "Logged as \(userIdentity.uri)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func touchedLogoutBarButton(sender : UIBarButtonItem) {
        Bit6.session().logoutWithCompletionHandler({(response,error) in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
                NSLog("Logout")
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
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let conversation = self.conversations[indexPath.row]
        let textLabel = cell.viewWithTag(1) as! UILabel
        let detailTextLabel = cell.viewWithTag(2) as! UILabel
        
        let messages = conversation.messages
        detailTextLabel.text = ConversationsViewController.contentStringForMessage(messages.last)
        
        if let group = Bit6Group(conversation:conversation) {
            if group.hasLeft {
                detailTextLabel.text = "You have left this group"
            }
        }
        
        let title = ConversationsViewController.titleForConversation(conversation)
        let badge = conversation.badge as NSNumber
        if badge.integerValue != 0 {
            textLabel.text = "\(title) (\(badge))"
        }
        else {
            textLabel.text = title
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete {
            let conversation = self.conversations[indexPath.row]
            if let group = Bit6Group(conversation:conversation) {
                
                //we haven't left the group, we do that before allowing deletion
                if !group.hasLeft {
                    group.leaveGroupWithCompletion{ (error)  in
                        if let error = error {
                            NSLog("Error \(error.localizedDescription)")
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            tableView.reloadData()
                        }
                    }
                }
                return
            }

            Bit6.deleteConversation(conversation, completion:nil)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let conversation = self.conversations[indexPath.row]

        if let group = Bit6Group(conversation:conversation) {
            //we haven't left the group, we do that before allowing deletion
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
            let conversation = self.conversations[indexPath!.row]
            ctvc.conversation = conversation
            ctvc.title = ConversationsViewController.titleForConversation(conversation)
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    
    // MARK: - Data Source changes
    
    //here we listen to changes in group members and group title
    func groupsChangedNotification(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let object = userInfo[Bit6ObjectKey] as! Bit6Group
        let change = userInfo[Bit6ChangeKey] as! NSString
        
        if change == Bit6UpdatedKey {
            let conversation = Bit6Conversation(address:object.address)
            if let indexPath = findConversation(conversation) {
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.None)
            }
        }
    }
    
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
        self.conversations.insert(conversation,atIndex:0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
    }
    
    func observeUpdatedBit6Object(conversation:Bit6Conversation) {
        if let indexPath = findConversation(conversation) {
            if indexPath.row != 0 {
                let firstConversation = self.conversations[0]
                let modifiedConversation = self.conversations[indexPath.row]
                if firstConversation.compare(modifiedConversation) == .OrderedDescending {
                    self.conversations.removeAtIndex(indexPath.row)
                    self.conversations.insert(conversation, atIndex:0)
                    self.tableView.moveRowAtIndexPath(indexPath, toIndexPath:NSIndexPath(forRow:0, inSection:0))
                }
                else {
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.None)
                }
            }
            else {
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.None)
            }
        }
    }
    
    func observeDeletedBit6Object(conversation:Bit6Conversation) {
        if let indexPath = findConversation(conversation) {
            self.conversations.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
    }
    
    func findConversation(conversation:Bit6Conversation) -> NSIndexPath? {
        
        for x in (0..<self.conversations.count).reverse() {
            if self.conversations[x].isEqual(conversation) {
                return NSIndexPath(forRow:x, inSection:0)
            }
        }
        return nil
    }
    
    // MARK: - Helpers
    
    static func contentStringForMessage(message:Bit6Message?) ->  String {
        if let message = message {
            if message.type == .Text {
                return message.content!
            }
            else if message.type == .Call {
                return "Call"
            }
            else if message.type == .Location {
                return "Location"
            }
            else {
                if message.attachFileType == .Audio {
                    return "Audio"
                }
                else if message.attachFileType == .Video {
                    return "Video"
                }
                else {
                    return "Photo"
                }
            }
        }
        return ""
    }
    
    static func titleForConversation(conversation:Bit6Conversation) ->  String {
        if let group = Bit6Group(conversation:conversation) {
            if let metadata = group.metadata {
                if let title = metadata[Bit6GroupMetadataTitleKey] as? String {
                    if title.characters.count > 0 {
                        return title
                    }
                }
            }
            
            let members = group.members
            var membersAddresses = members != nil ? members!.map {
                $0.address
                } : []
            membersAddresses.removeObject(Bit6.session().activeIdentity!)
            
            if membersAddresses.count > 1 {
                var title = ""
                for address in membersAddresses {
                    title += "\(address.uri), "
                }
                title.deleteCharactersInRange(NSMakeRange(title.characters.count-2,2))
                return title
            }
            else {
                return "Group"
            }
        }
        return conversation.address.uri
    }
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}

extension Array {
    var last: Element {
        return self[self.endIndex - 1]
    }
}

extension String {
    mutating func deleteCharactersInRange(range: NSRange) {
        let mutableSelf = NSMutableString(string: self)
        mutableSelf.deleteCharactersInRange(range)
        self = mutableSelf as String
    }
}
