//
//  ChatsViewController.m
//  Test
//
//  Created by Carlos Thurber Boaventura on 04/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ChatsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageAttachedViewController.h"
#import "UIBActionSheet.h"

@interface ChatsTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, Bit6ThumbnailImageViewDelegate, Bit6AudioRecorderControllerDelegate, Bit6CurrentLocationControllerDelegate, UITextFieldDelegate>
{
    BOOL scroll;
}

@property (strong, nonatomic) NSArray *messages;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *typingBarButtonItem;

@end

@implementation ChatsTableViewController

- (void) viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",[Bit6Session userIdentity].displayName];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    if (!scroll) {
        scroll = YES;
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX) animated:NO];
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[Bit6AudioPlayerController sharedInstance] stopPlayingAudioFile];
}

- (void)dealloc
{
    self.conversation.ignoreBadge = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Bit6MessagesUpdatedNotification object:self.conversation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Bit6TypingDidBeginRtNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Bit6TypingDidEndRtNotification object:nil];
}

- (void) setConversation:(Bit6Conversation *)conversation
{
    _conversation = conversation;
    _conversation.ignoreBadge = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagesUpdatedNotification:) name:Bit6MessagesUpdatedNotification object:conversation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingDidBeginRtNotification:) name:Bit6TypingDidBeginRtNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingDidEndRtNotification:) name:Bit6TypingDidEndRtNotification object:nil];
}

- (NSArray*)messages
{
    if (!_messages && self.conversation) {
        _messages = self.conversation.messages;
    }
    return _messages;
}

- (IBAction)touchedAttachButton:(UIBarButtonItem*)sender
{
    UIBActionSheet *as = [[UIBActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Take Video", @"Select Image", @"Select Video", @"Record Audio", @"Current Location", nil];
    [as showFromBarButtonItem:sender animated:YES dismissHandler:^(NSInteger selectedIndex, BOOL didCancel, BOOL didDestruct) {
        if (!didCancel) {
            switch (selectedIndex) {
                case 0: [self takePhoto]; break;
                case 1: [self takeVideo]; break;
                case 2: [self selectImage]; break;
                case 3: [self selectVideo]; break;
                case 4: [self sendAudio]; break;
                case 5: [self sendLocation]; break;
            }
        }
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    
    UITableViewCell *cell = nil;
    if (message.type == Bit6MessageType_Text) {
        static NSString *textInCellIdentifier = @"textInCell";
        static NSString *textOutCellIdentifier = @"textOutCell";
        cell = [tableView dequeueReusableCellWithIdentifier:message.incoming?textInCellIdentifier:textOutCellIdentifier];
    }
    else {
        static NSString *attachmentOutCellIdentifier = @"attachmentOutCell";
        static NSString *attachmentInCellIdentifier = @"attachmentInCell";
        cell = [tableView dequeueReusableCellWithIdentifier:message.incoming?attachmentInCellIdentifier:attachmentOutCellIdentifier];
    }
    
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.thumbnailImageViewDelegate = self;
    imageView.layer.borderWidth=1;
    imageView.layer.cornerRadius=10;
    imageView.layer.borderColor=[UIColor blackColor].CGColor;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    
    UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
    textLabel.text = message.content;
    
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.message = message;
    
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];
    switch (message.status) {
        case Bit6MessageStatus_Sending : detailTextLabel.text = @"Sending"; break;
        case Bit6MessageStatus_Sent : detailTextLabel.text = @"Sent"; break;
        case Bit6MessageStatus_Failed : detailTextLabel.text = @"Failed"; break;
        case Bit6MessageStatus_Delivered : detailTextLabel.text = @"Delivered"; break;
        case Bit6MessageStatus_Read : detailTextLabel.text = @"Read"; break;
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    [Bit6 deleteMessage:message];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.messages.count) {
        Bit6Message *message = self.messages[indexPath.row];
        return !message.incoming;
    }
    else {
        return NO;
    }
}

#pragma mark - Send Text

- (IBAction)touchedComposeButton:(id)sender {
    
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the message" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj textFieldAtIndex:0].delegate = self;
    [obj show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        NSString *msg = textfield.text;
        [self sendTextMsg:msg];
    }
}

- (void) sendTextMsg:(NSString*)msg
{
    if ([msg length]>0) {
        Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
        message.content = msg;
        message.destination = self.conversation.address;
        message.channel = Bit6MessageChannel_PUSH;
        [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
            if (!error) {
                NSLog(@"Message Sent");
            }
            else {
                NSLog(@"Message Failed with Error: %@",error.localizedDescription);
            }
        }];
    }
}

#pragma mark - Send Images/Videos

- (void)takePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)takeVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 60.0f;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeMovie];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectImage
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 60.0f;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeMovie];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        message.image = chosenImage;
    }
    else {
        NSURL *chosenVideo = info[UIImagePickerControllerMediaURL];
        message.videoURL = chosenVideo;
        message.videoCropStart = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        message.videoCropEnd = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
    }
    
    message.destination = self.conversation.address;
    message.channel = Bit6MessageChannel_PUSH;
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSLog(@"Message Sent");
        }
        else {
            NSLog(@"Message Failed with Error: %@",error.localizedDescription);
        }
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Send Locations

- (void)sendLocation
{
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    message.destination = self.conversation.address;
    message.channel = Bit6MessageChannel_PUSH;
    [[Bit6CurrentLocationController sharedInstance] startListeningToLocationForMessage:message delegate:self];
}

- (void) currentLocationController:(Bit6CurrentLocationController*)b6clc didFailWithError:(NSError*)error message:(Bit6OutgoingMessage*)message
{
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void) currentLocationController:(Bit6CurrentLocationController*)b6clc didGetLocationForMessage:(Bit6OutgoingMessage*)message
{
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSLog(@"Message Sent");
        }
        else {
            NSLog(@"Message Failed with Error: %@",error.localizedDescription);
        }
    }];
}

#pragma mark - Send Audio

- (void)sendAudio
{
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    message.destination = self.conversation.address;
    message.channel = Bit6MessageChannel_PUSH;
    [[Bit6AudioRecorderController sharedInstance] startRecordingAudioForMessage:message maxDuration:60 delegate:self errorHandler:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void) doneRecorderController:(Bit6AudioRecorderController*)b6rc message:(Bit6OutgoingMessage*)message
{
    [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSLog(@"Message Sent");
        }
        else {
            NSLog(@"Message Failed with Error: %@",error.localizedDescription);
        }
    }];
}

#pragma mark - Notifications

- (void) messagesUpdatedNotification:(NSNotification*)notification
{
    self.messages = nil;
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void) typingDidBeginRtNotification:(NSNotification*)notification
{
    Bit6Address *address = notification.object;
    if ([address isEqual:self.conversation.address]) {
        self.typingBarButtonItem.title = @"Typing...";
    }
}

- (void) typingDidEndRtNotification:(NSNotification*)notification
{
    Bit6Address *address = notification.object;
    if ([address isEqual:self.conversation.address]) {
        self.typingBarButtonItem.title = @"";
    }
}

#pragma mark -

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if (self.messages.count>0) {
        long section = 0;
        long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFullImage"]) {
        ImageAttachedViewController *iavc = segue.destinationViewController;
        iavc.message = (Bit6Message*)sender;
    }
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [Bit6 typingBeginToAddress:self.conversation.address];
    return YES;
}

#pragma mark - Bit6ThumbnailImageViewDelegate

- (void) touchedThumbnailImageView:(Bit6ThumbnailImageView*)thumbnailImageView
{
    Bit6Message *msg = thumbnailImageView.message;
    
    Bit6MessageAttachmentStatus fullAttachStatus = [msg attachmentStatusForAttachmentCategory:Bit6MessageAttachmentCategory_FULL_SIZE];
    
    if (msg.type == Bit6MessageType_Location) {
        //Open on AppleMaps
        [Bit6 openLocationOnMapsFromMessage:msg];
        /*
        //Open on GoogleMaps app, if available
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?q=%@,%@&zoom=14", msg.data.lat.description, msg.data.lng.description];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        */
        /*
        //Open in Waze app, if availble
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
            NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%@,%@&navigate=yes", msg.data.lat.description, msg.data.lng.description];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        */
    }
    else if (msg.type == Bit6MessageType_Attachments) {
        if (msg.attachFileType == Bit6MessageFileType_AudioMP4) {
            [[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:msg errorHandler:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }
        else if (msg.attachFileType == Bit6MessageFileType_VideoMP4) {
            if ([Bit6 shouldDownloadVideoBeforePlaying]) {
                if (fullAttachStatus==Bit6MessageAttachmentStatus_FOUND) {
                    [Bit6 playVideoFromMessage:msg viewController:self.navigationController];
                }
            }
            else {
                [Bit6 playVideoFromMessage:msg viewController:self.navigationController];
            }
        }
        else if (msg.attachFileType == Bit6MessageFileType_ImageJPG||msg.attachFileType == Bit6MessageFileType_ImagePNG) {
            [self performSegueWithIdentifier:@"showFullImage" sender:msg];
        }
    }
}

@end