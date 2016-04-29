//
//  ChatsViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 04/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ChatsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ConversationsViewController.h"

@interface ChatsTableViewController () <UITextFieldDelegate>
{
    BOOL scroll;
}

@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *typingBarButtonItem;

@end

@implementation ChatsTableViewController

- (void)setConversation:(Bit6Conversation *)conversation
{
    _conversation = conversation;
    [Bit6 setCurrentConversation:conversation];
    if (conversation.address.isGroup) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsChangedNotification:) name:Bit6GroupsChangedNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagesChangedNotification:) name:Bit6MessagesChangedNotification object:self.conversation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingBeginNotification:) name:Bit6TypingDidBeginRtNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingEndNotification:) name:Bit6TypingDidEndRtNotification object:nil];
}

- (NSArray*)messages
{
    if (!_messages && self.conversation) {
        _messages = [NSMutableArray arrayWithArray:self.conversation.messages];
    }
    return _messages;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.activeIdentity.uri];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bit6ui_phone"] style:UIBarButtonItemStylePlain target:self action:@selector(call)];
    
    if (self.conversation.typingAddress) {
        self.typingBarButtonItem.title = [NSString stringWithFormat:@"%@ is typing...",self.conversation.typingAddress.uri];
    }
    else {
        self.typingBarButtonItem.title = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    if (!scroll) {
        scroll = YES;
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX) animated:NO];
    }
}

- (void)dealloc
{
    [Bit6 setCurrentConversation:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    
    static NSString *textInCellIdentifier = @"textInCell";
    static NSString *textOutCellIdentifier = @"textOutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:message.incoming?textInCellIdentifier:textOutCellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Message *message = self.messages[indexPath.row];
    
    UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
    textLabel.text = [ChatsTableViewController textContentForMessage:message];
    
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];
    if (detailTextLabel) {
        if (message.type == Bit6MessageType_Call) {
            detailTextLabel.text = @"";
        }
        else {
            switch (message.status) {
                case Bit6MessageStatus_New : detailTextLabel.text = @""; break;
                case Bit6MessageStatus_Sending : detailTextLabel.text = @"Sending"; break;
                case Bit6MessageStatus_Sent : detailTextLabel.text = @"Sent"; break;
                case Bit6MessageStatus_Failed : detailTextLabel.text = @"Failed"; break;
                case Bit6MessageStatus_Delivered : detailTextLabel.text = @"Delivered"; break;
                case Bit6MessageStatus_Read : detailTextLabel.text = @"Read"; break;
            }
        }
    }
    
}

#pragma mark - Calls

- (void)call {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Audio Call" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [Bit6 startCallTo:self.conversation.address streams:Bit6CallStreams_Audio];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Video Call" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [Bit6 startCallTo:self.conversation.address streams:Bit6CallStreams_Audio|Bit6CallStreams_Video];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Send Text

- (IBAction)touchedComposeButton:(id)sender {
    if (!self.canChat) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You have left this group" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Type the message" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = weakSelf;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      UITextField *textField = alert.textFields[0];
                                                      NSString *msg = textField.text;
                                                      
                                                      Bit6OutgoingMessage *message = [Bit6OutgoingMessage new];
                                                      message.content = msg;
                                                      message.destination = self.conversation.address;
                                                      [message sendWithCompletionHandler:^(NSDictionary *response, NSError *error) {
                                                          if (!error) {
                                                              NSLog(@"Message Sent");
                                                          }
                                                          else {
                                                              NSLog(@"Message Failed with Error: %@",error.localizedDescription);
                                                          }
                                                      }];
                                                  }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Typing

- (void)typingBeginNotification:(NSNotification*)notification
{
    Bit6Address* fromAddress = notification.userInfo[Bit6FromKey];
    Bit6Address* convervationAddress = notification.object;
    if ([convervationAddress isEqual:self.conversation.address]) {
        self.typingBarButtonItem.title = [NSString stringWithFormat:@"%@ is typing...",fromAddress.uri];
    }
}
- (void)typingEndNotification:(NSNotification*)notification
{
    Bit6Address* convervationAddress = notification.object;
    if ([convervationAddress isEqual:self.conversation.address]) {
        self.typingBarButtonItem.title = nil;
    }
}

#pragma mark - Data Source changes

//here we listen to changes in group members and group title
- (void)groupsChangedNotification:(NSNotification*)notification
{
    Bit6Group *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6UpdatedKey] && [object.address isEqual:self.conversation.address]) {
        self.title = [ConversationsViewController titleForConversation:self.conversation];
    }
}

- (void)messagesChangedNotification:(NSNotification*)notification
{
    Bit6Message *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count inSection:0];
        [self.messages addObject:object];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self scrollToBottomAnimated:YES];
    }
    else if ([change isEqualToString:Bit6UpdatedKey]) {
        NSIndexPath *indexPath = [self findMessage:object];
        if (indexPath) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self tableView:self.tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        }
    }
    else if ([change isEqualToString:Bit6DeletedKey]) {
        NSIndexPath *indexPath = [self findMessage:object];
        if (indexPath) {
            [self.messages removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (NSIndexPath*)findMessage:(Bit6Message*)message
{
    NSUInteger index = NSNotFound;
    for (NSInteger x=self.messages.count-1; x>=0; x--) {
        if ([self.messages[x] isEqual:message]) {
            index = x;
            break;
        }
    }
    return [NSIndexPath indexPathForRow:index inSection:0];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [Bit6 typingBeginToAddress:self.conversation.address];
    return YES;
}

#pragma mark - Helpers

- (BOOL)canChat
{
    if (self.conversation.address.isGroup) {
        Bit6Group *group = [Bit6Group groupWithConversation:self.conversation];
        if (group.hasLeft) {
            return NO;
        }
    }
    return YES;
}

+ (NSString*)textContentForMessage:(nonnull Bit6Message*)message
{
    if (message.type == Bit6MessageType_Call) {
        
        BOOL showDuration = NO;
        
        NSString *status = @"";
        switch (message.callStatus) {
            case Bit6MessageCallStatus_Answer: status = @"Answer"; showDuration = YES; break;
            case Bit6MessageCallStatus_Missed: status = @"Missed"; break;
            case Bit6MessageCallStatus_Failed: status = @"Failed"; break;
            case Bit6MessageCallStatus_NoAnswer: status = @"No Answer"; break;
        }
        
        NSMutableArray *channels = [NSMutableArray arrayWithCapacity:3];
        if ([message callHasChannel:Bit6MessageCallChannel_Audio]){
            [channels addObject:@"Audio"];
        }
        if ([message callHasChannel:Bit6MessageCallChannel_Video]){
            [channels addObject:@"Video"];
        }
        if ([message callHasChannel:Bit6MessageCallChannel_Data]){
            [channels addObject:@"Data"];
        }
        
        NSString *channel = [channels componentsJoinedByString:@" + "];
        
        if (showDuration) {
            return [NSString stringWithFormat:@"%@ Call - %@s",channel, message.callDuration.description];
        }
        else {
            return [NSString stringWithFormat:@"%@ Call (%@)",channel, status];
        }
    }
    else if (message.type == Bit6MessageType_Location) {
        return @"Location";
    }
    else if (message.type == Bit6MessageType_Attachments) {
        return @"Attachment";
    }
    else {
        return message.content;
    }
}

@end
