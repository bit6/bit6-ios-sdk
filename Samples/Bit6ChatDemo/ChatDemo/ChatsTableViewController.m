//
//  ChatsViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 04/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ChatsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageAttachedViewController.h"
#import "UIBActionSheet.h"
#import "ConversationDetailsTableViewController.h"

@interface ChatsTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, Bit6ThumbnailImageViewDelegate, Bit6AudioRecorderControllerDelegate, Bit6CurrentLocationControllerDelegate, UITextFieldDelegate, Bit6MenuControllerDelegate>
{
    BOOL scroll;
    int alert_type;
}

@property (strong, nonatomic) Bit6Message *messageToForward;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *typingBarButtonItem;

@end

@implementation ChatsTableViewController

- (void) viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.userIdentity.displayName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(showDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *detailButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = detailButton;
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
    [Bit6.audioPlayer stopPlayingAudioFile];
}

- (void)dealloc
{
    self.conversation.currentConversation = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) canChat
{
    if ([self.conversation.address isKind:Bit6AddressKind_GROUP]) {
        Bit6Group *group = [Bit6Group groupForConversation:self.conversation];
        if (group.hasLeft) {
            return NO;
        }
    }
    return YES;
}

- (void) showDetailInfo
{
    [self performSegueWithIdentifier:@"showDetails" sender:nil];
}

- (void) setConversation:(Bit6Conversation *)conversation
{
    _conversation = conversation;
    _conversation.currentConversation = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationsChangedNotification:) name:Bit6ConversationsChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagesChangedNotification:) name:Bit6MessagesChangedNotification object:self.conversation];
}

- (NSArray*)messages
{
    if (!_messages && self.conversation) {
        _messages = [NSMutableArray arrayWithArray:self.conversation.messages];
    }
    return _messages;
}

- (IBAction)touchedAttachButton:(UIBarButtonItem*)sender
{
    if (!self.canChat) {
        [[[UIAlertView alloc] initWithTitle:@"You have left this group" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
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
    
    Bit6MessageLabel *textLabel = (Bit6MessageLabel*) [cell viewWithTag:1];
    textLabel.menuControllerDelegate = self;
    textLabel.layer.borderColor = [UIColor grayColor].CGColor;
    textLabel.layer.borderWidth = 0.7;
    
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.thumbnailImageViewDelegate = self;
    imageView.menuControllerDelegate = self;
    imageView.layer.borderWidth=1;
    imageView.layer.cornerRadius=10;
    imageView.layer.borderColor=[UIColor blackColor].CGColor;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    
    Bit6MessageLabel *textLabel = (Bit6MessageLabel*) [cell viewWithTag:1];
    textLabel.message = message;
    
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.message = message;
    
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];
    switch (message.status) {
        case Bit6MessageStatus_New : detailTextLabel.text = @""; break;
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
    [Bit6 deleteMessage:message completion:nil];
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
    if (!self.canChat) {
        [[[UIAlertView alloc] initWithTitle:@"You have left this group" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the message" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    alert_type = 0;
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj textFieldAtIndex:0].delegate = self;
    [obj show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        if (alert_type==0) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            NSString *msg = textfield.text;
            [self sendTextMsg:msg];
        }
        else {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            NSString *destination = textfield.text;
            if ([destination length]>0) {
                Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:destination];
                
                Bit6OutgoingMessage *msg = [Bit6OutgoingMessage outgoingCopyOfMessage:self.messageToForward];
                msg.destination = address;
                msg.channel = Bit6MessageChannel_PUSH;
                [msg sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
                    if (!error) {
                        NSLog(@"Message Sent");
                    }
                    else {
                        NSLog(@"Message Failed with Error: %@",error.localizedDescription);
                    }
                }];
            }
            self.messageToForward = nil;
        }
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
        message.videoURL = (NSURL*)info[UIImagePickerControllerMediaURL];;
        message.videoCropStart = info[@"_UIImagePickerControllerVideoEditingStart"];
        message.videoCropEnd = info[@"_UIImagePickerControllerVideoEditingEnd"];
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
    [Bit6.locationController startListeningToLocationForMessage:message delegate:self];
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
    [Bit6.audioRecorder startRecordingAudioForMessage:message maxDuration:60 delegate:self defaultPrompt:YES errorHandler:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void) doneRecorderController:(Bit6AudioRecorderController*)b6rc message:(Bit6OutgoingMessage*)message
{
    if (message.audioDuration) {
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

#pragma mark - Data Source changes

- (void) conversationsChangedNotification:(NSNotification*)notification
{
    Bit6Conversation *object = notification.userInfo[Bit6ObjectKey];
    
    if ([object isEqual:self.conversation]) {
        NSString *change = notification.userInfo[Bit6ChangeKey];
        if ([change isEqualToString:Bit6UpdatedKey]) {
            Bit6Group *group = [Bit6Group groupForConversation:self.conversation];
            self.title = [group.metadata[@"title"] length]>0?group.metadata[@"title"]:self.conversation.displayName;
            if (object.typingAddress) {
                self.typingBarButtonItem.title = [NSString stringWithFormat:@"%@ is typing...",object.typingAddress.displayName];
            }
            else {
                self.typingBarButtonItem.title = @"";
            }
        }
    }
}

- (void) messagesChangedNotification:(NSNotification*)notification
{
    Bit6Message *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        [self observeAddedMessage:object];
    }
    else if ([change isEqualToString:Bit6UpdatedKey]) {
        [self observeUpdatedMessage:object];
    }
    else if ([change isEqualToString:Bit6DeletedKey]) {
        [self observeDeletedMessage:object];
    }
}

- (void) observeAddedMessage:(Bit6Message*)message
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count inSection:0];
    [self.messages addObject:message];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self scrollToBottomAnimated:YES];
}

- (void) observeUpdatedMessage:(Bit6Message*)message
{
    NSUInteger index = NSNotFound;
    for (NSInteger x=self.messages.count-1; x>=0; x--) {
        if ([self.messages[x] isEqual:message]) {
            index = x;
            break;
        }
    }
    
    if (index!=NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self tableView:self.tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void) observeDeletedMessage:(Bit6Message*)message
{
    NSUInteger index = NSNotFound;
    for (NSInteger x=self.messages.count-1; x>=0; x--) {
        if ([self.messages[x] isEqual:message]) {
            index = x;
            break;
        }
    }
    
    if (index!=NSNotFound) {
        [self.messages removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - Bit6MenuControllerDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void) forwardMessage:(Bit6Message*)msg
{
    self.messageToForward = msg;
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the destination username" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert_type = 1;
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj show];
}

- (void) resendFailedMessage:(Bit6OutgoingMessage*)msg
{
    [msg sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFullImage"]) {
        ImageAttachedViewController *iavc = segue.destinationViewController;
        iavc.message = (Bit6Message*)sender;
    }
    else if ([segue.identifier isEqualToString:@"showDetails"]) {
        ConversationDetailsTableViewController *obj = segue.destinationViewController;
        obj.conversation = self.conversation;
        obj.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.userIdentity.displayName];
    }
}

#pragma mark - UITextFieldDelegate

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
            [Bit6.audioPlayer startPlayingAudioFileInMessage:msg errorHandler:^(NSError *error) {
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
