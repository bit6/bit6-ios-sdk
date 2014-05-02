//
//  MessagingViewController.m
//  Test
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ChatsViewController.h"

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
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",[Bit6Session userIdentity].description];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSArray*)conversations
{
    if (!_conversations) {
        _conversations = [Bit6Conversation conversations];
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
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the destination" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        NSString *destination = textfield.text;
        if ([destination length]>0) {
            Bit6Address *address = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME value:destination];
            Bit6Conversation *conversation = [[Bit6Conversation alloc] initWithAddress:address];
            [Bit6Conversation addConversation:conversation];
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
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Conversation *conversation = self.conversations[indexPath.row];
    UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    
    textLabel.text = conversation.address.description;
    Bit6Message *lastMessage = [conversation.messages lastObject];
    
    detailTextLabel.text = lastMessage.content;
    imageView.message = lastMessage;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Bit6Conversation *conversation = self.conversations[indexPath.row];
        [Bit6Conversation deleteConversation:conversation];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showChats"]) {
        ChatsViewController *cvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Bit6Conversation *conversation = self.conversations[indexPath.row];
        cvc.conversation = conversation;
        cvc.title = conversation.address.description;
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
