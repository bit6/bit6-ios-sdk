//
//  ConversationDetailsTableViewController.m
//  Bit6
//
//  Created by Carlos Thurber on 03/11/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "ConversationDetailsTableViewController.h"

@interface ConversationDetailsTableViewController ()

@property (nonatomic, strong) Bit6Group *group;
@property (nonatomic, weak) UITextField *subjectTextField;

@end

@implementation ConversationDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.group.isAdmin?self.editButtonItem:nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.subjectTextField resignFirstResponder];
}

- (void)setConversation:(Bit6Conversation *)conversation
{
    _conversation = conversation;
    self.group = [Bit6Group groupWithConversation:conversation];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.group.members.count+1 inSection:0];
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.group setMetadata:@{@"title":self.subjectTextField.text} completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Failed to change the title");
            }
        }];
    }
    
    self.subjectTextField.enabled = self.editing;
}

- (Bit6GroupMember*)memberForIndexPath:(NSIndexPath*)indexPath
{
    if (self.group) {
        Bit6GroupMember *member = self.group.members[indexPath.row-1];
        return member;
    }
    return nil;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.group) {
        if (self.group.hasLeft) {
            return 0;
        }
        else {
            return 1 + //title cell
            self.group.members.count + //members cells
            (self.editing?1:0); //cell to add member
        }
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    //title
    if (self.group && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"group_subject"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"group_subject"];
            UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            subjectLabel.text = @"Group subject: ";
            [subjectLabel sizeToFit];
            CGRect frame = subjectLabel.frame;
            frame.origin.x = 15;
            frame.origin.y = (44.0f - frame.size.height)/2;
            subjectLabel.frame = frame;
            [cell.contentView addSubview:subjectLabel];
            
            UITextField *subjectTextField = [[UITextField alloc] initWithFrame:CGRectZero];
            subjectTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            frame = subjectLabel.frame;
            frame.origin.x = CGRectGetMaxX(frame) + 5;
            frame.size.width = self.tableView.frame.size.width - frame.origin.x - 10;
            subjectTextField.frame = frame;
            subjectTextField.placeholder = @"<No Subject>";
            subjectTextField.enabled = self.editing;
            if ([self.group.metadata[@"title"] isKindOfClass:[NSString class]]) {
                NSString *title = self.group.metadata[@"title"];
                if (title.length>0) {
                    subjectTextField.text = title;
                }
            }
            [subjectTextField addTarget:self action:@selector(subjectTextFieldDidChange:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.contentView addSubview:subjectTextField];
            
            self.subjectTextField = subjectTextField;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //members
    else if (!self.group || (indexPath.row-1 < (int)self.group.members.count)) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"group_member"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"group_member"];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //add member
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"add_member"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add_member"];
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.group) {
        //title
        if (indexPath.row == 0) {
            
        }
        //members
        else if (indexPath.row-1 < (int)self.group.members.count) {
            Bit6GroupMember *member = [self memberForIndexPath:indexPath];
            cell.textLabel.text = member.address.uri;
            cell.detailTextLabel.text = [member.role isEqualToString:@"admin"]?@"Group Admin":@"";
        }
        //add member
        else {
            cell.textLabel.text = @"+ Add contact";
        }
    }
    else {
        cell.textLabel.text = self.conversation.address.uri;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.group.members.count+1){
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self inviteParticipant];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return NO; //title row
    else if ((indexPath.row-1) < self.group.members.count){
        Bit6GroupMember *member = [self memberForIndexPath:indexPath];
        return ![member.address isEqual:Bit6.session.activeIdentity]; //cannot delete himself
    }
    else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode (used to disable swipe-to-delete gesture)
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6GroupMember *member = [self memberForIndexPath:indexPath];
    [self.group kickGroupMember:member completion:^(NSArray *members, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self.tableView reloadData];
            }
        });
    }];
}

- (void)subjectTextFieldDidChange:(UITextField*)textField { }

#pragma mark - Invite

- (void)inviteParticipant
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Type the friend username to invite" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *userTextField = alert.textFields[0];
                                                NSString *string = userTextField.text;
                                                
                                                Bit6Address *address = [Bit6Address addressWithUsername:string];
                                                
                                                [self.group inviteGroupMemberWithAddress:address role:Bit6GroupMemberRoleUser completion:^(NSArray *members, NSError *error) {
                                                    if (error) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed to invite users to the group" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                                                            [self.navigationController presentViewController:alert animated:YES completion:nil];
                                                        });
                                                    }
                                                    else {
                                                        [self.tableView reloadData];
                                                    }
                                                }];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
