//
//  ChatsTableViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/08/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import MobileCoreServices

class ChatsTableViewController: UITableViewController, Bit6ThumbnailImageViewDelegate, Bit6MenuControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Bit6AudioRecorderControllerDelegate, Bit6CurrentLocationControllerDelegate {

    var conversation : Bit6Conversation! {
        didSet {
            conversation.ignoreBadge = true
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"messagesUpdatedNotification:", name: Bit6MessagesUpdatedNotification, object: self.conversation)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"typingDidBeginRtNotification:", name: Bit6TypingDidBeginRtNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"typingDidEndRtNotification:", name: Bit6TypingDidEndRtNotification, object: nil)
        }
    }
    
    var scroll : Bool
    var _messages : NSArray!
    var messages : NSArray {
        get {
            if (_messages != nil){
                return _messages
            }
            else {
                _messages = self.conversation.messages
                return _messages
            }
        }
        set(newMessages){
            _messages = newMessages
        }
    }
    
    @IBOutlet var typingBarButtonItem: UIBarButtonItem!
    
    required init(coder aDecoder: NSCoder) {
        self.scroll = false
        super.init(coder:aDecoder)
    }
    
    deinit {
        self.conversation.ignoreBadge = false
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6MessagesUpdatedNotification, object: self.conversation)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6TypingDidBeginRtNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Bit6TypingDidEndRtNotification, object: nil)
    }
    
    override func viewDidLoad() {
        self.navigationItem.prompt = NSString(format: "Logged as %@", Bit6.session().userIdentity.displayName);
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        if (!self.scroll) {
            self.scroll = true;
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: false)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        Bit6.audioPlayer().stopPlayingAudioFile()
    }
    
    @IBAction func touchedAttachButton(sender : UIBarButtonItem) {
        var alert = UIAlertController(title:nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            self.takePhoto();
        }))
        alert.addAction(UIAlertAction(title: "Take Video", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            self.takeVideo()
        }))
        alert.addAction(UIAlertAction(title: "Select Image", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            self.selectImage()
        }))
        alert.addAction(UIAlertAction(title: "Select Video", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            self.selectVideo()
        }))
        alert.addAction(UIAlertAction(title: "Record Audio", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            self.sendAudio()
        }))
        alert.addAction(UIAlertAction(title: "Current Location", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            self.sendLocation()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            
        }))
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var message = self.messages[indexPath.row] as Bit6Message;
        var cell : UITableViewCell
        if (message.type == Bit6MessageType.Text) {
            if (message.incoming){
                cell = tableView.dequeueReusableCellWithIdentifier("textInCell") as UITableViewCell
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("textOutCell") as UITableViewCell
            }

            var view = cell.viewWithTag(1)
            if (view != nil){
                var textLabel = cell.viewWithTag(1) as UILabel
                if (message.incoming){
                    textLabel.textAlignment = NSTextAlignment.Left
                }
                else {
                    textLabel.textAlignment = NSTextAlignment.Right
                }
            }
        }
            
        else {
            if (message.incoming){
                cell = tableView.dequeueReusableCellWithIdentifier("attachmentInCell") as UITableViewCell
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("attachmentOutCell") as UITableViewCell
            }
        }
        
        var view = cell.viewWithTag(1)
        if (view != nil){
            var textLabel = view as Bit6MessageLabel
            textLabel.menuControllerDelegate = self;
            textLabel.layer.borderColor = UIColor.grayColor().CGColor;
            textLabel.layer.borderWidth = 0.7;
        }
        
        view = cell.viewWithTag(3)
        if (view != nil){
            var imageView = view as Bit6ThumbnailImageView
            imageView.thumbnailImageViewDelegate = self
            imageView.menuControllerDelegate = self;
            imageView.layer.borderWidth=1;
            imageView.layer.cornerRadius=10;
            imageView.layer.borderColor=UIColor.blackColor().CGColor
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var message = self.messages[indexPath.row] as Bit6Message;
        
        var view = cell.viewWithTag(1)
        if ((view) != nil){
            var textLabel = view as Bit6MessageLabel
            textLabel.message = message
        }
        view = cell.viewWithTag(2)
        if ((view) != nil){
            var detailTextLabel = view as UILabel
            
            if (message.incoming){
                detailTextLabel.text = ""
            }
            else {
                switch (message.status){
                case Bit6MessageStatus.New :
                    detailTextLabel.text = ""
                case Bit6MessageStatus.Sending :
                    detailTextLabel.text = "Sending"
                case Bit6MessageStatus.Sent :
                    detailTextLabel.text = "Sent"
                case Bit6MessageStatus.Failed :
                    detailTextLabel.text = "Failed"
                case Bit6MessageStatus.Delivered :
                    detailTextLabel.text = "Delivered"
                case Bit6MessageStatus.Read :
                    detailTextLabel.text = "Read"
                }
            }
        }
        
        view = cell.viewWithTag(3)
        if ((view) != nil){
            var imageView = view as Bit6ThumbnailImageView
            imageView.message = message
        }
    }
    
    // MARK: - Send Text
    
    @IBAction func touchedComposeButton(sender : UIBarButtonItem) {
        var alert = UIAlertController(title:"Type the message", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            var msgTextField = alert.textFields?[0] as UITextField
            self.sendTextMsg(msgTextField.text)
        }))
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Message"
            textField.delegate = self
        })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }

    func sendTextMsg(msg : NSString){
        if (msg.length > 0){
            var message = Bit6OutgoingMessage()
            message.content = msg
            message.destination = self.conversation.address
            message.channel = Bit6MessageChannel.PUSH
            message.sendWithCompletionHandler({ (response, error) -> Void in
                if (error == nil){
                    NSLog("Message Sent");
                }
                else {
                    NSLog("Message Failed with Error: %@",error.localizedDescription);
                }
            })
        }
    }
    
    // MARK: - Send Images/Videos
    
    func takePhoto() -> Void {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeImage]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func takeVideo() -> Void {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 60.0
        imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeMovie]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func selectImage() -> Void {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func selectVideo() -> Void {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 60.0
        imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie]
        self.navigationController?.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        var message = Bit6OutgoingMessage()
        var mediaType = info[UIImagePickerControllerMediaType] as NSString
        if (mediaType.isEqualToString(kUTTypeImage)){
            var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
            message.image = chosenImage
        }
        else {
            message.videoURL = info[UIImagePickerControllerMediaURL] as NSURL
            message.videoCropStart = info["_UIImagePickerControllerVideoEditingStart"] as NSNumber
            message.videoCropEnd = info["_UIImagePickerControllerVideoEditingEnd"] as NSNumber
        }
        
        message.destination = self.conversation.address
        message.channel = Bit6MessageChannel.PUSH
        message.sendWithCompletionHandler { (response, error) -> Void in
            if (error == nil){
                NSLog("Message Sent");
            }
            else {
                NSLog("Message Failed with Error: %@",error.localizedDescription);
            }
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Send Locations
    
    func sendLocation() -> Void {
        var message = Bit6OutgoingMessage()
        message.destination = self.conversation.address
        message.channel = Bit6MessageChannel.PUSH
        Bit6.locationController().startListeningToLocationForMessage(message, delegate: self)
    }
    
    func currentLocationController(b6clc: Bit6CurrentLocationController!, didFailWithError error: NSError!, message: Bit6OutgoingMessage!) {
        var alert = UIAlertController(title:error.localizedDescription, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    func currentLocationController(b6clc: Bit6CurrentLocationController!, didGetLocationForMessage message: Bit6OutgoingMessage!) {
        message.sendWithCompletionHandler { (response, error) -> Void in
            if (error == nil) {
                NSLog("Message Sent");
            }
            else {
                NSLog("Message Failed with Error: %@",error.localizedDescription);
            }
        }
    }
    
    // MARK: - Send Audio
    
    func sendAudio() -> Void {
        var message = Bit6OutgoingMessage()
        message.destination = self.conversation.address
        message.channel = Bit6MessageChannel.PUSH
        Bit6.audioRecorder().startRecordingAudioForMessage(message, maxDuration: 60, delegate: self, defaultPrompt: true, errorHandler:{ (error) -> Void in
            var alert = UIAlertController(title:error.localizedDescription, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
            self.navigationController?.presentViewController(alert, animated: true, completion:nil)
        })
    }
    
    func doneRecorderController(b6rc: Bit6AudioRecorderController!, message: Bit6OutgoingMessage!) {
        if (message.audioDuration > 1.0){
            message.sendWithCompletionHandler { (response, error) -> Void in
                if (error == nil) {
                    NSLog("Message Sent");
                }
                else {
                    NSLog("Message Failed with Error: %@",error.localizedDescription);
                }
            }
        }
    }
    
    // MARK: - Notifications
    
    func messagesUpdatedNotification(notification:NSNotification) {
        _messages = nil
        self.tableView.reloadData()
        self.scrollToBottomAnimated(true)
    }
    
    func typingDidBeginRtNotification(notification:NSNotification) {
        var address = notification.object as Bit6Address
        if (address.isEqual(self.conversation.address)){
            self.typingBarButtonItem.title = "Typing..."
        }
    }
    
    func typingDidEndRtNotification(notification:NSNotification) {
        var address = notification.object as Bit6Address
        if (address.isEqual(self.conversation.address)){
            self.typingBarButtonItem.title = ""
        }
    }
    
    // MARK: -
    
    func scrollToBottomAnimated(animated:Bool){
        if (self.messages.count>0){
            var section = 0
            var row = self.tableView(self.tableView, numberOfRowsInSection: section)-1
            var scrollIndexPath = NSIndexPath(forRow: row, inSection: section)
            self.tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
        }
    }
    
    // MARK: - Bit6MenuControllerDelegate
    
    override
    func scrollViewWillBeginDragging(scrollView:UIScrollView){
        UIMenuController.sharedMenuController().setMenuVisible(false, animated:true)
    }
    
    func forwardMessage(msg:Bit6Message){
        var alert = UIAlertController(title:"Type the destination username", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{(action :UIAlertAction!) in
            var usernameTextField = alert.textFields?[0] as UITextField
            if ((usernameTextField.text as NSString).length>0){
                var address = Bit6Address(kind: Bit6AddressKind.USERNAME, value: usernameTextField.text)
                var message = Bit6OutgoingMessage.outgoingCopyOfMessage(msg)
                message.destination = address
                message.channel = Bit6MessageChannel.PUSH
                message.sendWithCompletionHandler { (response, error) -> Void in
                    if (error == nil) {
                        NSLog("Message Sent");
                    }
                    else {
                        NSLog("Message Failed with Error: %@",error.localizedDescription);
                    }
                }
            }
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
        })
        
        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
    }
    
    func resendFailedMessage(msg:Bit6OutgoingMessage){
        msg.sendWithCompletionHandler { (response, error) -> Void in
            if (error == nil) {
                NSLog("Message Sent");
            }
            else {
                NSLog("Message Failed with Error: %@",error.localizedDescription);
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "showFullImage"){
            var iavc = segue.destinationViewController as ImageAttachedViewController
            iavc.message = sender as Bit6Message
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
        var msg = thumbnailImageView.message
        
        var fullAttachStatus = msg.attachmentStatusForAttachmentCategory(Bit6MessageAttachmentCategory.FULL_SIZE)
        
        if (msg.type == Bit6MessageType.Location){
            //Open in AppleMaps
            Bit6.openLocationOnMapsFromMessage(msg)
            
            /*
            //Open in GoogleMaps app, if available
            var urlString = String(format:"comgooglemaps://?center=%@,%@&zoom=14",
            message.data.lat.description, message.data.lng.description)
            var url = NSURL(string: urlString)
            if (UIApplication.sharedApplication().canOpenURL(url!)){
            UIApplication.sharedApplication().openURL(url!)
            }
            */
            
            /*
            //Open in Waze app, if available
            var urlString = String(format:"waze://?ll=%@,%@&navigate=yes",
            message.data.lat.description, message.data.lng.description)
            var url = NSURL(string: urlString)
            if (UIApplication.sharedApplication().canOpenURL(url!)){
            UIApplication.sharedApplication().openURL(url!)
            }
            */
        }
            
        else if (msg.type == Bit6MessageType.Attachments) {
            if (msg.attachFileType == Bit6MessageFileType.AudioMP4) {
                Bit6.audioPlayer().startPlayingAudioFileInMessage(msg,errorHandler: { (error) -> Void in
                        var alert = UIAlertController(title:error.localizedDescription, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
                        self.navigationController?.presentViewController(alert, animated: true, completion:nil)
                })
            }
            else if (msg.attachFileType == Bit6MessageFileType.VideoMP4) {
                if (Bit6.shouldDownloadVideoBeforePlaying()) {
                    if (fullAttachStatus==Bit6MessageAttachmentStatus.FOUND) {
                        Bit6.playVideoFromMessage(msg, viewController:self.navigationController);
                    }
                }
                else {
                    Bit6.playVideoFromMessage(msg, viewController:self.navigationController);
                }
            }
            else if (msg.attachFileType == Bit6MessageFileType.ImageJPG||msg.attachFileType == Bit6MessageFileType.ImagePNG) {
                self.performSegueWithIdentifier("showFullImage", sender:msg)
            }
        }
    }
}
