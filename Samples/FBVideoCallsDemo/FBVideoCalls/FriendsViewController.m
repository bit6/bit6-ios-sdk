//
//  FriendsViewController.m
//  FBVideoCalls
//
//  Created by Carlos Thurber on 12/19/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate, FBSDKAppInviteDialogDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *friendsDict;
@property (strong, nonatomic) NSArray *friendsIds;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [self loadFacebookFriends];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(touchedLogoutBarButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteFriendsButtonTouched:)];
    
    [super viewDidLoad];
}

- (void)touchedLogoutBarButton:(id)sender {
    [Bit6.session logoutWithCompletionHandler:nil];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *friendId = self.friendsIds[indexPath.row];
    NSString *name = self.friendsDict[friendId];
    cell.textLabel.text = name;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *friendId = self.friendsIds[indexPath.row];
    NSString *name = self.friendsDict[friendId];
    
    Bit6Address *address = [Bit6Address addressWithFacebookId:friendId];
    
    Bit6CallController *callController = [Bit6 createCallTo:address streams:Bit6CallStreams_Audio|Bit6CallStreams_Video];
    callController.otherDisplayName = name;
    Bit6CallViewController *callViewController = [Bit6 callViewController] ?: [Bit6CallViewController createDefaultCallViewController];
    [callViewController addCallController:callController];
    [callController start];
    [Bit6 presentCallViewController:callViewController];
}

#pragma mark - Facebook

- (void) loadFacebookFriends
{
    __weak FriendsViewController *conv = self;
    FBSDKGraphRequest *graph = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends"
                                                                 parameters:@{@"fields":@"name,first_name,last_name,id"}
                                                                 HTTPMethod:@"GET"];
    
    [graph startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *result, NSError *error) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:result.count];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:result.count];
        
        NSArray* friends = result[@"data"];
        for (NSDictionary* friend in friends) {
            [array addObject:friend[@"id"]];
            dict[friend[@"id"]] = friend[@"name"];
        }
        
        conv.friendsIds = array;
        conv.friendsDict = dict;
        
        [conv.tableView reloadData];
    }];
}

#pragma mark - Invite Friends

- (void) inviteFriendsButtonTouched:(UIBarButtonItem*)sender
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    #warning Remember to set your invitation url
    content.appLinkURL = [NSURL URLWithString:@""];
    FBSDKAppInviteDialog *dialog = [[FBSDKAppInviteDialog alloc] init];
    dialog.content = content;
    dialog.delegate = self;
    
    if ([dialog canShow]) {
        [dialog show];
    }
    else {
        NSLog(@"Can't show");
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        params[kv[0]] = val;
    }
    return params;
}

#pragma mark - FBSDKAppInviteDialogDelegate

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    
}

@end
