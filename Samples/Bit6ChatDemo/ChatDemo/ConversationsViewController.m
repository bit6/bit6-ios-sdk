//
//  MessagingViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ChatsTableViewController.h"

@interface ConversationsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *conversations;

@end

@implementation ConversationsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationsUpdatedNotification:) name:Bit6ConversationsUpdatedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Bit6ConversationsUpdatedNotification object:nil];
}

- (void)viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",[Bit6Session userIdentity].displayName];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSArray*)conversations
{
    if (!_conversations) {
        _conversations = [Bit6 conversations];
    }
    return _conversations;
}

#pragma mark - Action

- (IBAction)touchedLogoutBarButton:(id)sender {
    [Bit6Session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)touchedAddButton:(id)sender {
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the destination username" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        NSString *destination = textfield.text;
        if ([destination length]>0) {
            Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:destination];
            Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
            if (conversation) {
                [Bit6 addConversation:conversation];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Invalid username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"conversationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.layer.borderWidth=1;
    imageView.layer.cornerRadius=10;
    imageView.layer.borderColor=[UIColor blackColor].CGColor;
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Conversation *conversation = self.conversations[indexPath.row];
    UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    
    NSNumber *badge = conversation.badge;
    textLabel.text = [NSString stringWithFormat:@"%@%@",conversation.displayName,[badge intValue]!=0?[NSString stringWithFormat:@" (%@)",badge]:@""];
    Bit6Message *lastMessage = [conversation.messages lastObject];
    
    detailTextLabel.text = lastMessage.content;
    imageView.message = lastMessage;
    imageView.hidden = !lastMessage || (lastMessage.type == Bit6MessageType_Text);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Bit6Conversation *conversation = self.conversations[indexPath.row];
        [Bit6 deleteConversation:conversation];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showChats"]) {
        ChatsTableViewController *ctvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Bit6Conversation *conversation = self.conversations[indexPath.row];
        ctvc.conversation = conversation;
        ctvc.title = conversation.displayName;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Notifications

- (void) conversationsUpdatedNotification:(NSNotification*)notification
{
    self.conversations = nil;
    [self.tableView reloadData];
}

@end
