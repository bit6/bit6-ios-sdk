//
//  ChatsViewController.m
//  Test
//
//  Created by Carlos Thurber Boaventura on 04/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ChatsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AttachmentsTableViewController.h"

@interface ChatsTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, Bit6ThumbnailImageViewDelegate, Bit6AudioRecorderControllerDelegate, Bit6CurrentLocationControllerDelegate>
{
    BOOL scroll;
}

@property (strong, nonatomic) NSArray *messages;

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
        [self.tableView reloadData];
        scroll = YES;
        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX) animated:NO];
    }
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    self.conversation.ignoreBadge = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Bit6MessagesUpdatedNotification object:self.conversation];
}

- (void) setConversation:(Bit6Conversation *)conversation
{
    _conversation = conversation;
    _conversation.ignoreBadge = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagesUpdatedNotification:) name:Bit6MessagesUpdatedNotification object:conversation];
}

- (NSArray*)messages
{
    if (!_messages && self.conversation) {
        _messages = self.conversation.messages;
    }
    return _messages;
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
        
        UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
        textLabel.textAlignment = message.incoming?NSTextAlignmentLeft:NSTextAlignmentRight;
    }
    else {
        static NSString *attachmentOutCellIdentifier = @"attachmentOutCell";
        static NSString *attachmentInCellIdentifier = @"attachmentInCell";
        cell = [tableView dequeueReusableCellWithIdentifier:message.incoming?attachmentInCellIdentifier:attachmentOutCellIdentifier];
    }
    
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.thumbnailImageViewDelegate = self;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    int status = message.status;
    
    UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];

    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    
    textLabel.text = message.content;
    if (message.incoming) {
        detailTextLabel.text = nil;
    }
    else {
        detailTextLabel.text = status==Bit6MessageStatus_Sent?@"Sent":(status==Bit6MessageStatus_Sending?@"Sending":@"Failed");
    }
    
    imageView.message = message;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    NSString *content = message.content;
    
    CGFloat height = [content sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height + 58.0f;
    
    return MAX(80.0f,height);
}

#pragma mark - Send Text

- (IBAction)touchedComposeButton:(id)sender {
    
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the message" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textfield = [alertView textFieldAtIndex:0];
    NSString *msg = textfield.text;
    if (buttonIndex!=alertView.cancelButtonIndex) {
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
}

#pragma mark - Send Images

- (IBAction)touchedSendImageButton:(id)sender {
    
    UIImagePickerController *imgController = [[UIImagePickerController alloc] init];
    imgController.delegate=self;
    imgController.allowsEditing = NO;
    imgController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.mediaTypes = @[(NSString *) kUTTypeImage];
    [self.navigationController presentViewController:imgController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    message.image = chosenImage;
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

- (IBAction)touchedSendLocationButton:(id)sender {
    
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    message.destination = self.conversation.address;
    message.channel = Bit6MessageChannel_PUSH;
    [[Bit6CurrentLocationController sharedInstance] startListeningToLocationForMessage:message delegate:self];
}

- (void) doneGettingCurrentLocationController:(Bit6CurrentLocationController*)b6clc message:(Bit6OutgoingMessage*)message
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

- (IBAction)touchedSendAudioButton:(id)sender {
    Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
    message.destination = self.conversation.address;
    message.channel = Bit6MessageChannel_PUSH;
    [[Bit6AudioRecorderController sharedInstance] startRecordingAudioForMessage:message maxDuration:60 delegate:self noMicBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"No Access to Microphone" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
    if ([segue.identifier isEqualToString:@"showAttachments"]) {
        AttachmentsTableViewController *atvc = segue.destinationViewController;
        atvc.attachmentMessagesArray = [Bit6 messagesWithAttachmentInMessages:self.messages];
        atvc.title = self.title;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Bit6ThumbnailImageViewDelegate

- (void) touchedThumbnailImageView:(Bit6ThumbnailImageView*)thumbnailImageView
{
    Bit6Message *msg = thumbnailImageView.message;
    if (msg.type == Bit6MessageType_Location) {
        [msg openLocationOnMaps];
    }
    else if (msg.type == Bit6MessageType_Attachments) {
        if (msg.attachFileType == Bit6MessageFileType_AudioMP4) {
            [[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:msg];
        }
    }
}

@end