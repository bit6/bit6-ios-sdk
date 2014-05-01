//
//  ChatsViewController.m
//  Test
//
//  Created by Carlos Thurber Boaventura on 04/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ChatsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChatsViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Bit6ThumbnailImageViewDelegate, Bit6AudioRecorderControllerDelegate, Bit6CurrentLocationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatsViewController

- (void) viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",[Bit6Session userIdentity].description];
    [self scrollToBottomAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void) setConversation:(Bit6Conversation *)conversation
{
    _conversation = conversation;
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
        static NSString *textCellIdentifier = @"textCell";
        cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
        
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
    //class=Bit6ThumbnailImageView and tag=3 have been set in the storyboard
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
    [[Bit6AudioRecorderController sharedInstance] startRecordingAudioForMessage:message maxDuration:60 delegate:self];
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
        long row = [self.tableView numberOfRowsInSection:section] - 1;
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
