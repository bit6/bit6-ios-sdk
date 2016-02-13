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

class ChatsTableViewController: UITableViewController, Bit6ThumbnailImageViewDelegate, Bit6MenuControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Bit6AudioRecorderControllerDelegate, Bit6CurrentLocationControllerDelegate {

    var conversation : Bit6Conversation! {
        didSet {
            Bit6.setCurrentConversation(conversation)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"messagesChangedNotification:", name: Bit6MessagesChangedNotification, object: self.conversation)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"conversationsChangedNotification:", name: Bit6ConversationsChangedNotification, object: nil)
        }
    }
    
    var scroll : Bool
    var _messages : NSMutableArray!
    var messages : NSMutableArray {
        get {
            if _messages != nil{
                return _messages
            }
            else {
                _messages = NSMutableArray(array:self.conversation.messages)
                return _messages
            }
        }
        set(newMessages){
            _messages = newMessages
        }
    }
    
    @IBOutlet var typingBarButtonItem: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        self.scroll = false
        super.init(coder:aDecoder)
    }
    
    deinit {
        Bit6.setCurrentConversation(nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func canChat() -> Bool {
        if let group = Bit6Group(conversation:self.conversation) {
            if group.hasLeft {
                return false
            }
            return true
        }
        return false
    }
    
    func showDetailInfo() {
        self.performSegueWithIdentifier("showDetails", sender:nil)
    }
    
    override func viewDidLoad() {
        if let userIdentity = Bit6.session().activeIdentity {
            self.navigationItem.prompt = "Logged as \(userIdentity.displayName)"
        }
    
        let button = UIButton(type: .InfoLight)
        button.addTarget(self, action:"showDetailInfo", forControlEvents:.TouchUpInside)
        let detailButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = detailButton
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Bit6.audioPlayer().stopPlayingAudioFile()
    }
    
    @IBAction func touchedAttachButton(sender : UIBarButtonItem) {
        
        if !self.canChat() {
            let alert = UIAlertController(title:"You have left this group", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action :UIAlertAction) in
            }))
            self.navigationController?.presentViewController(alert, animated: true, completion:nil)
            return;
        }
        
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler:{(action :UIAlertAction) in
            self.takePhoto()
        }))
        alert.addAction(UIAlertAction(title: "Take Video", style: .Default, handler:{(action :UIAlertAction) in
            self.takeVideo()
        }))
        alert.addAction(UIAlertAction(title: "Select Image", style: .Default, handler:{(action :UIAlertAction) in
            self.selectImage()
        }))
        alert.addAction(UIAlertAction(title: "Select Video", style: .Default, handler:{(action :UIAlertAction) in
            self.selectVideo()
        }))
        alert.addAction(UIAlertAction(title: "Record Audio", style: .Default, handler:{(action :UIAlertAction) in
            self.sendAudio()
        }))
        alert.addAction(UIAlertAction(title: "Current Location", style: .Default, handler:{(action :UIAlertAction) in
            self.sendLocation()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
        }))
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let message = self.messages[indexPath.row] as! Bit6Message
        var cell : UITableViewCell
        if message.type == .Text {
            if message.incoming {
                cell = tableView.dequeueReusableCellWithIdentifier("textInCell")!
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("textOutCell")!
            }

            let view = cell.viewWithTag(1)
            if view != nil{
                let textLabel = cell.viewWithTag(1) as! UILabel
                if message.incoming {
                    textLabel.textAlignment = .Left
                }
                else {
                    textLabel.textAlignment = .Right
                }
            }
        }
            
        else {
            if message.incoming {
                cell = tableView.dequeueReusableCellWithIdentifier("attachmentInCell")!
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("attachmentOutCell")!
            }
        }
        
        if let textLabel = cell.viewWithTag(1) as? Bit6MessageLabel{
            textLabel.menuControllerDelegate = self
            textLabel.layer.borderColor = UIColor.grayColor().CGColor
            textLabel.layer.borderWidth = 0.7
        }
        
        if let imageView = cell.viewWithTag(3) as? Bit6ThumbnailImageView {
            imageView.thumbnailImageViewDelegate = self
            imageView.menuControllerDelegate = self
            imageView.layer.borderWidth=1
            imageView.layer.cornerRadius=10
            imageView.layer.borderColor=UIColor.blackColor().CGColor
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let message = self.messages[indexPath.row] as! Bit6Message
        
        if let textLabel = cell.viewWithTag(1) as? Bit6MessageLabel{
            textLabel.message = message
        }
        if let detailTextLabel = cell.viewWithTag(2) as? UILabel{
            if message.incoming {
                detailTextLabel.text = ""
            }
            else {
                switch message.status {
                case .New :
                    detailTextLabel.text = ""
                case .Sending :
                    detailTextLabel.text = "Sending"
                case .Sent :
                    detailTextLabel.text = "Sent"
                case .Failed :
                    detailTextLabel.text = "Failed"
                case .Delivered :
                    detailTextLabel.text = "Delivered"
                case .Read :
                    detailTextLabel.text = "Read"
                }
            }
        }
        
        if let imageView = cell.viewWithTag(3) as? Bit6ThumbnailImageView {
            imageView.message = message
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row < self.messages.count {
            let message = self.messages[indexPath.row] as! Bit6Message
            return !message.incoming
        }
        else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let message = self.messages[indexPath.row] as! Bit6Message
        Bit6.deleteMessage(message, completion:nil)
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
            let message = Bit6OutgoingMessage()
            message.content = msg as String
            message.destination = self.conversation.address
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
    
    // MARK: - Send Images/Videos
    
    func takePhoto() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func takeVideo() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 60.0
        imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func selectImage() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func selectVideo() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 60.0
        imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let message = Bit6OutgoingMessage()
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        let imageType = kUTTypeImage as String
        if mediaType == imageType {
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            message.image = chosenImage
        }
        else {
            message.videoURL = info[UIImagePickerControllerMediaURL] as? NSURL
            message.videoCropStart = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            message.videoCropEnd = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
        }
        
        message.destination = self.conversation.address
        message.sendWithCompletionHandler { (response, error) in
            if error == nil {
                NSLog("Message Sent")
            }
            else {
                NSLog("Message Failed with Error: \(error?.localizedDescription)")
            }
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Send Locations
    
    func sendLocation() -> Void {
        let message = Bit6OutgoingMessage()
        message.destination = self.conversation.address
        Bit6.locationController().startListeningToLocationForMessage(message, delegate: self)
    }
    
    func currentLocationController(b6clc: Bit6CurrentLocationController, didFailWithError error: NSError, message: Bit6OutgoingMessage) {
        let alert = UIAlertController(title:error.localizedDescription, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    func currentLocationController(b6clc: Bit6CurrentLocationController, didGetLocationForMessage message: Bit6OutgoingMessage) {
        message.sendWithCompletionHandler { (response, error) in
            if error == nil {
                NSLog("Message Sent")
            }
            else {
                NSLog("Message Failed with Error: \(error?.localizedDescription)")
            }
        }
    }
    
    // MARK: - Send Audio
    
    func sendAudio() -> Void {
        Bit6.audioRecorder().startRecordingAudioWithMaxDuration(60, delegate:self, defaultPrompt:true, errorHandler:{ (error)  in
            if let error = error {
                let alert = UIAlertController(title:error.localizedDescription, message: nil, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                self.navigationController?.presentViewController(alert, animated: true, completion:nil)
            }
        })
    }
    
    func doneRecorderController(b6rc: Bit6AudioRecorderController, filePath: String) {
        let message = Bit6OutgoingMessage()
        message.destination = self.conversation.address
        message.audioFilePath = filePath
        
        if message.audioDuration > 1.0 {
            message.sendWithCompletionHandler { (response, error) in
                if error == nil {
                    NSLog("Message Sent")
                }
                else {
                    NSLog("Message Failed with Error: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    func isRecordingWithController(b6rc: Bit6AudioRecorderController, filePath: String) {
        
    }
    
    func cancelRecorderController(b6rc: Bit6AudioRecorderController) {
        
    }
    
    // MARK: - Data Source changes
    
    func conversationsChangedNotification(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let object = userInfo[Bit6ObjectKey] as! Bit6Conversation
        
        if object.isEqual(self.conversation) {
            let change = userInfo[Bit6ChangeKey] as! NSString
            if change == Bit6UpdatedKey {
                var title = conversation.address.displayName
                
                if let group = Bit6Group(conversation:self.conversation) {
                    if let metadata = group.metadata {
                        if let groupTitle = metadata[Bit6GroupMetadataTitleKey] as? String {
                            if groupTitle.characters.count>0 {
                                title = groupTitle
                            }
                        }
                    }
                }
                
                self.title = title
            
                if let typingAddress = object.typingAddress {
                    self.typingBarButtonItem.title = "\(typingAddress.displayName) is typing..."
                }
                else {
                    self.typingBarButtonItem.title = ""
                }
            }
        }
    }
    
    func messagesChangedNotification(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let object = userInfo[Bit6ObjectKey] as! Bit6Message
        let change = userInfo[Bit6ChangeKey] as! NSString
        
        if change == Bit6AddedKey {
            self.observeAddedMessage(object)
        }
        else if change == Bit6UpdatedKey {
            self.observeUpdatedMessage(object)
        }
        else if change == Bit6DeletedKey {
            self.observeDeletedMessage(object)
        }
    }
    
    
    func observeAddedMessage(message:Bit6Message) {
        let indexPath = NSIndexPath(forRow: self.messages.count, inSection: 0)
        self.messages.addObject(message)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        self.scrollToBottomAnimated(true)
    }
    
    func observeUpdatedMessage(message:Bit6Message) {
        var index = NSNotFound
        for var x = self.messages.count-1 ; x>=0 ; x-- {
            if self.messages[x].isEqual(message) {
                index = x
                break
            }
        }
        
        if index != NSNotFound {
            let indexPath = NSIndexPath(forRow:index, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            if cell != nil {
                self.tableView(self.tableView, willDisplayCell:cell!, forRowAtIndexPath:indexPath)
            }
        }
    }
    
    func observeDeletedMessage(message:Bit6Message) {
        var index = NSNotFound
        for var x = self.messages.count-1 ; x>=0 ; x-- {
            if self.messages[x].isEqual(message) {
                index = x
                break
            }
        }
        
        if index != NSNotFound {
            self.messages.removeObjectAtIndex(index)
            let indexPath = NSIndexPath(forRow:index, inSection: 0)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
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
    
    // MARK: - Bit6MenuControllerDelegate
    
    override
    func scrollViewWillBeginDragging(scrollView:UIScrollView){
        UIMenuController.sharedMenuController().setMenuVisible(false, animated:true)
    }
    
    func forwardMessage(msg:Bit6Message){
        let alert = UIAlertController(title:"Type the destination username", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{(action :UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{(action :UIAlertAction) in
            let usernameTextField = alert.textFields![0]
            if let username = usernameTextField.text {
                if let address = Bit6Address(username:username) {
                    let message = Bit6OutgoingMessage.outgoingCopyOfMessage(msg)
                    message.destination = address
                    message.sendWithCompletionHandler { (response, error) in
                        if error == nil {
                            NSLog("Message Sent")
                        }
                        else {
                            NSLog("Message Failed with Error: \(error?.localizedDescription)")
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
    
    func resendFailedMessage(msg:Bit6OutgoingMessage){
        msg.sendWithCompletionHandler{ (response, error) in
            if error == nil {
                NSLog("Message Sent")
            }
            else {
                NSLog("Message Failed with Error: \(error?.localizedDescription)")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showFullImage" {
            let iavc = segue.destinationViewController as! ImageAttachedViewController
            iavc.message = sender as! Bit6Message
        }
        else if segue.identifier == "showDetails" {
            let obj = segue.destinationViewController as! ConversationDetailsTableViewController
            obj.conversation = self.conversation;
            if let userIdentity = Bit6.session().activeIdentity {
                obj.navigationItem.prompt = "Logged as \(userIdentity.displayName)"
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        Bit6.typingBeginToAddress(self.conversation.address)
        return true
    }
    
    // MARK: - Bit6ThumbnailImageViewDelegate
    
    func touchedThumbnailImageView(thumbnailImageView:Bit6ThumbnailImageView) {
        guard let msg = thumbnailImageView.message else { return }
        
        let fullAttachStatus = msg.statusForFullAttachment
        
        if msg.type == .Location{
            //Open in AppleMaps
            Bit6.openLocationOnMapsFromMessage(msg)
            
            /*
            //Open in GoogleMaps app, if available
            var urlString = "comgooglemaps://?center=\(message.data.lat.description),\(message.data.lng.description)&zoom=14"
            var url = NSURL(string: urlString)
            if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
            }
            */
            
            /*
            //Open in Waze app, if available
            var urlString = "waze://?ll=\(message.data.lat.description),\(message.data.lng.description)&navigate=yes",
            var url = NSURL(string: urlString)
            if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
            }
            */
            
        }
            
        else if msg.type == .Attachments {
            if msg.attachFileType == .Audio {
                if let audioPath = msg.pathForFullAttachment {
                    Bit6.audioPlayer().startPlayingAudioFileAtPath(audioPath, errorHandler: { (error) in
                        let alert = UIAlertController(title:error.localizedDescription, message: nil, preferredStyle: .ActionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
                        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                    })
                }
            }
            else if msg.attachFileType == .Video {
                if Bit6.shouldDownloadVideoBeforePlaying() {
                    if fullAttachStatus == .FOUND {
                        Bit6.playVideoFromMessage(msg, viewController:self.navigationController!)
                    }
                }
                else {
                    Bit6.playVideoFromMessage(msg, viewController:self.navigationController!)
                }
            }
            else if msg.attachFileType == .Image {
                self.performSegueWithIdentifier("showFullImage", sender:msg)
            }
        }
    }
}
