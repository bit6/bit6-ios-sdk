//
//  ChatsTableViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/08/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import MobileCoreServices
import Bit6

class ChatsTableViewController: UITableViewController, UITextFieldDelegate {

    var conversation : Bit6Conversation! {
        didSet {
            Bit6.setCurrentConversation(conversation)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatsTableViewController.messagesChangedNotification(_:)), name: Bit6MessagesChangedNotification, object: self.conversation)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatsTableViewController.groupsChangedNotification(_:)), name: Bit6GroupsChangedNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatsTableViewController.typingBeginNotification(_:)), name: Bit6TypingDidBeginRtNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatsTableViewController.typingEndNotification(_:)), name: Bit6TypingDidEndRtNotification, object: nil)
        }
    }
    
    var scroll : Bool
    var _messages : [Bit6Message]!
    var messages : [Bit6Message] {
        get {
            if _messages != nil{
                return _messages
            }
            else {
                _messages = self.conversation.messages
                return _messages
            }
        }
        set {
            _messages = newValue
        }
    }
    
    
    @IBOutlet var typingBarButtonItem: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        self.scroll = false
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userIdentity = Bit6.session().activeIdentity {
            self.navigationItem.prompt = "Logged as \(userIdentity.uri)"
        }
    
        let callItem = UIBarButtonItem(image:UIImage(named:"bit6ui_phone"), style:.Plain, target:self, action:#selector(ChatsTableViewController.call))
        
        self.navigationItem.rightBarButtonItem = callItem
        
        if let typingAddress = self.conversation.typingAddress {
            self.typingBarButtonItem.title = "\(typingAddress.uri) is typing..."
        }
        else {
            self.typingBarButtonItem.title = nil;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        if !self.scroll {
            self.scroll = true
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: false)
        }
    }
    
    deinit {
        Bit6.setCurrentConversation(nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let message = self.messages[indexPath.row]
        var cell : UITableViewCell
        
        if message.incoming {
            cell = tableView.dequeueReusableCellWithIdentifier("textInCell")!
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("textOutCell")!
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let message = self.messages[indexPath.row]
        
        if let textLabel = cell.viewWithTag(1) as? UILabel {
            textLabel.text = ChatsTableViewController.textContentForMessage(message)
        }
        
        if let detailTextLabel = cell.viewWithTag(2) as? UILabel {
            if message.type == .Call {
                detailTextLabel.text = ""
            }
            else {
                switch message.status {
                case .New : detailTextLabel.text = ""
                case .Sending : detailTextLabel.text = "Sending"
                case .Sent : detailTextLabel.text = "Sent"
                case .Failed : detailTextLabel.text = "Failed"
                case .Delivered : detailTextLabel.text = "Delivered"
                case .Read : detailTextLabel.text = "Read"
                }
            }
        }
    }
    
    // MARK: - Calls
    
    //WARNING: change to Bit6CallMediaModeMix to enable recording during a call
    static let callMediaMode = Bit6CallMediaModeP2P
    
    func call() {
        let actionSheet = UIAlertController(title:nil, message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Audio Call", style: .Default, handler:{(action :UIAlertAction) in
            Bit6.startCallTo(self.conversation.address, streams:[.Audio], mediaMode:ChatsTableViewController.callMediaMode, offnet: false)
        }))
        actionSheet.addAction(UIAlertAction(title: "Video Call", style: .Default, handler:{(action :UIAlertAction) in
            Bit6.startCallTo(self.conversation.address, streams:[.Audio,.Video], mediaMode:ChatsTableViewController.callMediaMode, offnet: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        
        self.navigationController?.presentViewController(actionSheet, animated: true, completion:nil)
    }
    
    // MARK: - Send Text
    
    @IBAction func touchedComposeButton(sender : UIBarButtonItem) {
        
        if !self.canChat() {
            let alert = UIAlertController(title:"You have left this group", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction) in
            }))
            self.navigationController?.presentViewController(alert, animated: true, completion:nil)
            return;
        }
        
        let alert = UIAlertController(title:"Type the message", message: nil, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler:{(action :UIAlertAction) in
            let msgTextField = alert.textFields![0]
            
            guard let text = msgTextField.text else {
                return
            }
            
            self.sendTextMsg(text)
        }))
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Message"
            textField.delegate = self
        })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }

    func sendTextMsg(msg : NSString){
        if msg.length > 0 {
            let message = Bit6OutgoingMessage(destination:self.conversation.address)
            message.content = msg as String
            message.sendWithCompletionHandler{ (response, error) in
                if error == nil {
                    NSLog("Message Sent")
                }
                else {
                    NSLog("Message Failed with Error: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Typing
    
    func typingBeginNotification(notification:NSNotification) {
        let userInfo = notification.userInfo!
        let fromAddress = userInfo[Bit6FromKey] as! Bit6Address
        let convervationAddress = notification.object as! Bit6Address
        if convervationAddress == self.conversation.address {
            self.typingBarButtonItem.title = "\(fromAddress.uri) is typing..."
        }
    }
    
    func typingEndNotification(notification:NSNotification) {
        let convervationAddress = notification.object as! Bit6Address
        if convervationAddress == self.conversation.address {
            self.typingBarButtonItem.title = nil
        }
    }
    
    // MARK: - Data Source changes
    
    //here we listen to changes in group members and group title
    func groupsChangedNotification(notification:NSNotification) {
        let userInfo = notification.userInfo!
        let object = userInfo[Bit6ObjectKey] as! Bit6Group
        let change = userInfo[Bit6ChangeKey] as! String
        
        if change == Bit6UpdatedKey && object.address == self.conversation.address {
            self.title = ConversationsViewController.titleForConversation(self.conversation)
        }
    }
    
    func messagesChangedNotification(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let object = userInfo[Bit6ObjectKey] as! Bit6Message
        let change = userInfo[Bit6ChangeKey] as! String
        
        if change == Bit6AddedKey {
            let indexPath = NSIndexPath(forRow: self.messages.count, inSection: 0)
            self.messages.append(object)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
            self.scrollToBottomAnimated(true)
        }
        else if change == Bit6UpdatedKey {
            if let indexPath = findMessage(object) {
                let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                if cell != nil {
                    self.tableView(self.tableView, willDisplayCell:cell!, forRowAtIndexPath:indexPath)
                }
            }
        }
        else if change == Bit6DeletedKey {
            if let indexPath = findMessage(object) {
                self.messages.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
            }
        }
    }
    
    func findMessage(message:Bit6Message) -> NSIndexPath? {
            for x in (0..<self.messages.count).reverse() {
            if self.messages[x].isEqual(message) {
                return NSIndexPath(forRow:x, inSection:0)
            }
        }
        return nil
    }
    
    // MARK: -
    
    func scrollToBottomAnimated(animated:Bool){
        if self.messages.count>0 {
            let section = 0
            let row = self.tableView(self.tableView, numberOfRowsInSection: section)-1
            let scrollIndexPath = NSIndexPath(forRow: row, inSection: section)
            self.tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        Bit6.typingBeginToAddress(self.conversation.address)
        return true
    }
    
    // MARK: - Helpers
    
    func canChat() -> Bool {
        if let group = Bit6Group(conversation:self.conversation) {
            if group.hasLeft {
                return false
            }
        }
        return true
    }
    
    class func textContentForMessage(message:Bit6Message) -> String? {
        if message.type == .Call {
            var showDuration = false
            
            var status = ""
            switch message.callStatus {
            case .Answer: status = "Answer"; showDuration = true;
            case .Missed: status = "Missed";
            case .Failed: status = "Failed";
            case .NoAnswer: status = "No Answer";
            }
            
            var channels = [String]()
            
            if message.callHasChannel(.Audio) {
                channels.append("Audio")
            }
            if message.callHasChannel(.Video) {
                channels.append("Video");
            }
            if message.callHasChannel(.Data) {
                channels.append("Data");
            }
            
            let channel = channels.joinWithSeparator(" + ")
            
            if showDuration {
                return "\(channel) Call - \(message.callDuration!.description)s"
            }
            else {
                return "\(channel) Call (\(status))"
            }
        }
        else if message.type == .Location {
            return "Location"
        }
        else if message.type == .Attachments {
            return "Attachment"
        }
        else {
            return message.content;
        }
    }
}
