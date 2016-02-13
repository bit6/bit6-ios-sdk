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
@property (strong, nonatomic) NSMutableArray *conversations;

@end

@implementation ConversationsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationsChangedNotification:) name:Bit6ConversationsChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.activeIdentity.displayName];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSMutableArray*)conversations
{
    if (!_conversations) {
        _conversations = [NSMutableArray arrayWithArray:[Bit6 conversations]];
    }
    return _conversations;
}

#pragma mark - Action

- (IBAction)touchedLogoutBarButton:(id)sender {
    [Bit6.session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (! error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)touchedAddButton:(id)sender {
    UIAlertView *obj = [[UIAlertView alloc] initWithTitle:@"Type the destination username, or type several usernames separated by comma to create a group conversation" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
    [obj show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        NSString *string = textfield.text;
        
        NSArray *destinations = [string componentsSeparatedByString:@","];
        
        if (destinations.count == 1) {
            Bit6Address *address = [Bit6Address addressWithUsername:destinations[0]];
            Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
            if (conversation) {
                [Bit6 addConversation:conversation];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Invalid username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        else if (destinations.count>1) {
            
            NSMutableArray *addresses = [NSMutableArray arrayWithCapacity:destinations.count];
            NSMutableArray *roles = [NSMutableArray arrayWithCapacity:destinations.count];
            for (NSString *destination in destinations) {
                Bit6Address *address = [Bit6Address addressWithUsername:destination];
                if (address) {
                    [addresses addObject:address];
                    [roles addObject:Bit6GroupMemberRole_User];
                }
            }
            
            [Bit6Group createGroupWithMetadata:@{@"title":@"MyGroup"} completion:^(Bit6Group *group, NSError *error) {
                if (!error) {
                    [group inviteGroupMembersWithAddresses:addresses roles:roles completion:^(NSArray *members, NSError *error) {
                        if (error) {
                            [[[UIAlertView alloc] initWithTitle:@"Failed to invite users to the group" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Failed to create the Group" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
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
    
    Bit6Group *group = [Bit6Group groupWithConversation:conversation];
    
    NSNumber *badge = conversation.badge;
    textLabel.text = [NSString stringWithFormat:@"%@%@",[group.metadata[@"title"] length]>0?group.metadata[@"title"]:conversation.address.displayName,[badge intValue]!=0?[NSString stringWithFormat:@" (%@)",badge]:@""];
    Bit6Message *lastMessage = [conversation.messages lastObject];
    
    detailTextLabel.text = lastMessage.content;
    imageView.message = lastMessage;
    imageView.hidden = !lastMessage || (lastMessage.type == Bit6MessageType_Text);
    
    if (group && group.hasLeft) {
        detailTextLabel.text = @"You have left this group";
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Bit6Conversation *conversation = self.conversations[indexPath.row];
        Bit6Group *group = [Bit6Group groupWithConversation:conversation];
        if (group != nil && !group.hasLeft) {
            [group leaveGroupWithCompletion:^(NSError *error) {
                if (error) {
                    NSLog(@"Error %@",error.localizedDescription);
                }
            }];
            return;
        }
        
        [Bit6 deleteConversation:conversation completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Conversation *conversation = self.conversations[indexPath.row];
    Bit6Group *group = [Bit6Group groupWithConversation:conversation];
    if (group != nil) {
        return group.hasLeft?@"Delete":@"Leave";
    }
    else {
        return @"Delete";
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
        Bit6Group *group = [Bit6Group groupWithConversation:conversation];
        ctvc.title = [group.metadata[@"title"] length]>0?group.metadata[@"title"]:conversation.address.displayName;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Data Source changes

- (void) conversationsChangedNotification:(NSNotification*)notification
{
    Bit6Conversation *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        [self observeAddedBit6Object:object];
    }
    if ([change isEqualToString:Bit6UpdatedKey]) {
        [self observeUpdatedBit6Object:object];
    }
    if ([change isEqualToString:Bit6DeletedKey]) {
        [self observeDeletedBit6Object:object];
    }
}

- (void) observeAddedBit6Object:(Bit6Conversation*)conversation
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.conversations insertObject:conversation atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) observeUpdatedBit6Object:(Bit6Conversation*)conversation
{
    NSUInteger index = NSNotFound;
    for (NSInteger x=self.conversations.count-1; x>=0; x--) {
        if ([self.conversations[x] isEqual:conversation]) {
            index = x;
            break;
        }
    }
    
    if (index!=NSNotFound) {
        if (index!=0) {
            Bit6Conversation *firstConversation = self.conversations[0];
            Bit6Conversation *modifiedConversation = self.conversations[index];
            NSComparisonResult compare = [firstConversation compare:modifiedConversation];
            if (compare == NSOrderedDescending) {
                [self.conversations removeObjectAtIndex:index];
                [self.conversations insertObject:conversation atIndex:0];
                [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
            else {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void) observeDeletedBit6Object:(Bit6Conversation*)conversation
{
    NSUInteger index = NSNotFound;
    for (NSInteger x=self.conversations.count-1; x>=0; x--) {
        if ([self.conversations[x] isEqual:conversation]) {
            index = x;
            break;
        }
    }
    
    if (index!=NSNotFound) {
        [self.conversations removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
