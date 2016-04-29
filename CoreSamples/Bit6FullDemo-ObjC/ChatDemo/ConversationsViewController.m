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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsChangedNotification:) name:Bit6GroupsChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.activeIdentity.uri];
}

- (void)viewWillAppear:(BOOL)animated
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

#pragma mark - Actions

- (IBAction)touchedLogoutBarButton:(id)sender {
    [Bit6.session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (! error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)touchedAddButton:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Type one username to start a direct conversation, or type several usernames separated by comma to create a group conversation" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *userTextField = alert.textFields[0];
                                                NSString *string = userTextField.text;
                                                
                                                NSArray *usernames = [string componentsSeparatedByString:@","];
                                                
                                                //direct conversation
                                                if (usernames.count == 1) {
                                                    Bit6Address *address = [Bit6Address addressWithUsername:usernames[0]];
                                                    Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
                                                    if (conversation) {
                                                        [Bit6 addConversation:conversation];
                                                    }
                                                    else {
                                                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid username" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                                                        [self.navigationController presentViewController:alert animated:YES completion:nil];
                                                    }
                                                }
                                                
                                                //group conversation
                                                else if (usernames.count>1) {
                                                    NSMutableArray *addresses = [NSMutableArray arrayWithCapacity:usernames.count];
                                                    for (NSString *destination in usernames) {
                                                        Bit6Address *address = [Bit6Address addressWithUsername:destination];
                                                        if (address) {
                                                            [addresses addObject:address];
                                                        }
                                                    }
                                                    
                                                    //creating the group
                                                    [Bit6Group createGroupWithMetadata:@{@"title":@"MyGroup"} completion:^(Bit6Group *group, NSError *error) {
                                                        if (!error) {
                                                            
                                                            //inviting the users to the group
                                                            [group inviteGroupMembersWithAddresses:addresses role:Bit6GroupMemberRole_User completion:^(NSArray *members, NSError *error) {
                                                                if (error) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed to invite users to the group" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                                                                        [self.navigationController presentViewController:alert animated:YES completion:nil];
                                                                    });
                                                                }
                                                            }];
                                                            
                                                        }
                                                        else {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed to create the Group" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                                                                [self.navigationController presentViewController:alert animated:YES completion:nil];
                                                            });
                                                        }
                                                    }];
                                                }
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"conversationCell";
    return [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6Conversation *conversation = self.conversations[indexPath.row];
    UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
    UILabel *detailTextLabel = (UILabel*) [cell viewWithTag:2];
    
    Bit6Message *lastMessage = [conversation.messages lastObject];
    NSNumber *badge = conversation.badge;
    detailTextLabel.text = [ConversationsViewController contentStringForMessage:lastMessage];
    
    NSString *title = [ConversationsViewController titleForConversation:conversation];
    if (conversation.address.isGroup) {
        Bit6Group *group = [Bit6Group groupWithConversation:conversation];
        if (group.hasLeft) {
            detailTextLabel.text = @"You have left this group";
        }
    }
    
    textLabel.text = [NSString stringWithFormat:@"%@%@",title,[badge intValue]!=0?[NSString stringWithFormat:@" (%@)",badge]:@""];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Bit6Conversation *conversation = self.conversations[indexPath.row];
        Bit6Group *group = [Bit6Group groupWithConversation:conversation];
        if (group != nil && !group.hasLeft) {
            
            //we haven't left the group, we do that before allowing deletion
            [group leaveGroupWithCompletion:^(NSError *error) {
                if (error) {
                    NSLog(@"Error %@",error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
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
        //we haven't left the group, we do that before allowing deletion
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
        ctvc.title = [ConversationsViewController titleForConversation:conversation];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Data Source changes

//here we listen to changes in group members and group title
- (void)groupsChangedNotification:(NSNotification*)notification
{
    Bit6Group *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6UpdatedKey]) {
        NSIndexPath *indexPath = [self findConversation:[Bit6Conversation conversationWithAddress:object.address]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)conversationsChangedNotification:(NSNotification*)notification
{
    Bit6Conversation *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    
    if ([change isEqualToString:Bit6AddedKey]) {
        [self observeAddedBit6Object:object];
    }
    else if ([change isEqualToString:Bit6UpdatedKey]) {
        [self observeUpdatedBit6Object:object];
    }
    else if ([change isEqualToString:Bit6DeletedKey]) {
        [self observeDeletedBit6Object:object];
    }
}

- (void)observeAddedBit6Object:(Bit6Conversation*)conversation
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.conversations insertObject:conversation atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)observeUpdatedBit6Object:(Bit6Conversation*)conversation
{
    NSIndexPath *indexPath = [self findConversation:conversation];
    if (indexPath) {
        if (indexPath.row!=0) {
            Bit6Conversation *firstConversation = self.conversations[0];
            Bit6Conversation *modifiedConversation = self.conversations[indexPath.row];
            if ([firstConversation compare:modifiedConversation] == NSOrderedDescending) {
                [self.conversations removeObjectAtIndex:indexPath.row];
                [self.conversations insertObject:conversation atIndex:0];
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
            else {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)observeDeletedBit6Object:(Bit6Conversation*)conversation
{
    NSIndexPath *indexPath = [self findConversation:conversation];
    if (indexPath) {
        [self.conversations removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSIndexPath*)findConversation:(Bit6Conversation*)conversation
{
    for (NSInteger x=self.conversations.count-1; x>=0; x--) {
        if ([self.conversations[x] isEqual:conversation]) {
            return [NSIndexPath indexPathForRow:x inSection:0];
        }
    }
    return nil;
}

#pragma mark - Helpers

+ (NSString*)contentStringForMessage:(Bit6Message*)message
{
    if (!message) {
        return nil;
    }
    else if (message.type == Bit6MessageType_Text){
        return message.content;
    }
    else if (message.type == Bit6MessageType_Call){
        return @"Call";
    }
    else if (message.type == Bit6MessageType_Location) {
        return @"Location";
    }
    else {
        if (message.attachFileType == Bit6MessageFileType_Audio) {
            return @"Recording";
        }
        else if (message.attachFileType == Bit6MessageFileType_Video) {
            return @"Video";
        }
        else {
            return @"Photo";
        }
    }
}

+ (NSString*)titleForConversation:(Bit6Conversation*)conversation
{
    if (conversation.address.isGroup) {
        Bit6Group *group = [Bit6Group groupWithConversation:conversation];
        
        NSString *subject = group.metadata[Bit6GroupMetadataTitleKey];
        if (subject.length > 0) {
            return subject;
        }
        else {
            NSMutableArray *membersAddresses = [[group.members valueForKey:@"address"] mutableCopy];
            [membersAddresses removeObject:Bit6.session.activeIdentity];
            
            if (membersAddresses.count > 1) {
                NSMutableString *string = [NSMutableString stringWithCapacity:60];
                for (Bit6Address *address in membersAddresses) {
                    [string appendFormat:@"%@, ",address.uri];
                }
                [string deleteCharactersInRange:NSMakeRange(string.length-2, 2)];
                return string;
            }
            else {
                return @"Group";
            }
        }
    }
    
    return conversation.address.uri;
}

@end
