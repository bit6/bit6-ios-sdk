//
//  MessagingViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ChatsTableViewController.h"

@implementation ConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bit6";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
}

- (void)logout
{
    [Bit6.session logoutWithCompletionHandler:^(NSDictionary<id,id> * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:NO];
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
                                                            [group inviteGroupMembersWithAddresses:addresses role:Bit6GroupMemberRoleUser completion:^(NSArray *members, NSError *error) {
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

#pragma mark - Navigation

- (void)didSelectConversation:(Bit6Conversation*)conversation {
    [self performSegueWithIdentifier:@"showConversation" sender:conversation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showConversation"]) {
        ChatsTableViewController *vc = (ChatsTableViewController*)segue.destinationViewController;
        Bit6Conversation *conv = sender;
        vc.address = conv.address;
    }
}

@end
