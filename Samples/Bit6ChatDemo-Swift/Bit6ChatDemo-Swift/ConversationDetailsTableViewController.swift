//
//  ConversationDetailsTableViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 03/31/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

import UIKit

class ConversationDetailsTableViewController: UITableViewController {

    var group : Bit6Group!
    var subjectTextField : UITextField!
    
    var conversation : Bit6Conversation! {
        didSet {
            conversation.currentConversation = true
            self.group = Bit6Group(forConversation:conversation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        
        if (self.group != nil && self.group.isAdmin) {
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
        }
        
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, 0.001))
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.subjectTextField != nil) {
            self.subjectTextField.resignFirstResponder()
        }
    }
    
    override func setEditing(editing:Bool, animated:Bool) {
        super.setEditing(editing, animated:animated)
        var indexPath = NSIndexPath(forRow: self.group.members.count+1, inSection: 0)
        if (editing) {
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
        else {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
            
            self.group.setMetadata(["title":self.subjectTextField.text], completion:{ (error) -> Void in
                if (error != nil) {
                    NSLog("Failed to change the title")
                }
            })
        }
        
        self.subjectTextField.enabled = self.editing
    }

    func memberForIndexPath(indexPath:NSIndexPath) -> Bit6GroupMember! {
        if (self.group != nil) {
            var member = self.group.members[indexPath.row-1] as Bit6GroupMember
            return member
        }
        return nil
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.group != nil) {
            if (self.group.hasLeft) {
                return 0
            }
            else {
                return 1 + //title cell
                    self.group.members.count + //members cells
                    (self.editing ? 1 : 0) //cell to add member
            }
        }
        else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //title
        if (self.group != nil && indexPath.row == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("group_subject") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "group_subject")
                var subjectLabel = UILabel(frame: CGRectZero)
                subjectLabel.text = "Group subject: "
                subjectLabel.sizeToFit()
                var frame = subjectLabel.frame
                frame.origin.x = 15
                frame.origin.y = (44.0 - frame.size.height)/2
                subjectLabel.frame = frame;
                cell.contentView.addSubview(subjectLabel)
                
                var subjectTextField = UITextField(frame: CGRectZero)
                subjectTextField.clearButtonMode = .WhileEditing
                frame = subjectLabel.frame;
                frame.origin.x = CGRectGetMaxX(frame) + 5;
                frame.size.width = self.tableView.frame.size.width - frame.origin.x - 10;
                subjectTextField.frame = frame;
                subjectTextField.placeholder = Bit6EmptyGroupSubject;
                subjectTextField.enabled = self.editing;
                
                var title = self.group.metadata!["title"] as NSString!
                if let title = title {
                    subjectTextField.text = title
                }
                subjectTextField.addTarget(self, action:"subjectTextFieldDidChange:", forControlEvents:.EditingDidEndOnExit)
                cell.contentView.addSubview(subjectTextField)
                
                self.subjectTextField = subjectTextField;
            }
            cell.selectionStyle = .None
            return cell
        }
            
            //members
        else if (self.group == nil  || (indexPath.row-1 < self.group.members.count)) {
            var cell = tableView.dequeueReusableCellWithIdentifier("group_member") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "group_member")
                cell.detailTextLabel!.textColor = UIColor.redColor()
                cell.detailTextLabel!.font = UIFont.systemFontOfSize(14)
            }
            cell.selectionStyle = .None
            return cell
        }
            
            //add member
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("add_member") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "add_member")
                cell.textLabel!.textColor = UIColor(red: 0, green: 0.478431, blue: 1.0, alpha: 1.0)
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (self.group != nil) {
            //title
            if (indexPath.row == 0) {
                
            }
                //members
            else if (indexPath.row-1 < self.group.members.count) {
                var member = self.memberForIndexPath(indexPath)
                cell.textLabel!.text = member.address.displayName
                cell.detailTextLabel!.text = member.role == "admin" ? "Group Admin" : ""
            }
                //add member
            else {
                cell.textLabel!.text = "+ Add contact";
            }
        }
        else {
            cell.textLabel!.text = self.conversation.address.displayName;
        }
    }
    
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView:UITableView, willSelectRowAtIndexPath indexPath:NSIndexPath) -> NSIndexPath? {
        if (indexPath.row == self.group.members.count+1) {
            return indexPath
        }
        return nil
    }
    
    override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        self.inviteParticipant()
    }
    
    override func tableView(tableView:UITableView, canEditRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        if (indexPath.row == 0) { return false } //title row
        else if ((indexPath.row-1) < self.group.members.count){
            var member = self.memberForIndexPath(indexPath)
            return !member.address.isEqual(Bit6.session().userIdentity) //cannot delete himself
        }
        else {
            return false;
        }
    }
    
    override func tableView(tableView:UITableView, editingStyleForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCellEditingStyle {
        // Detemine if it's in editing mode (used to disable swipe-to-delete gesture)
        if (self.tableView.editing) {
            return .Delete
        }
        return .None
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        var member = self.memberForIndexPath(indexPath)
        self.group.deleteMember(member, completion:{(members, error) in
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func subjectTextFieldDidChange(textField:UITextField) { }

    // MARK: - Invite
    
    func inviteParticipant() {
        var alert = UIAlertController(title:"Type the friend username to invite", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(action :UIAlertAction!) in
            var usernameTextField = alert.textFields?[0] as UITextField
            if ((usernameTextField.text as NSString).length>0){
                
                var destinations =  [usernameTextField.text]
                
                if (destinations.count == 1) {
                    
                    var addresses = NSMutableArray(capacity: destinations.count)
                    
                    for (index, element) in enumerate(destinations) {
                        var address = Bit6Address(kind: .USERNAME, value: element)
                        if (address != nil) {
                            addresses.addObject(address)
                        }
                    }
                    
                    self.group.inviteAddresses(addresses, completion:{ (members, error) -> Void in
                        if (error != nil){
                            var alert = UIAlertController(title:"Failed to invite users to the group", message: nil, preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction!) in
                            }))
                            self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                        }
                        else {
                            self.tableView.reloadData()
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
}
