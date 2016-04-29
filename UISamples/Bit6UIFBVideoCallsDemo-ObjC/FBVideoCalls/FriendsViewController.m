//
//  FriendsViewController.m
//  FBVideoCalls
//
//  Created by Carlos Thurber on 12/19/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "FriendsViewController.h"
#import "DemoContactSource.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate, FBSDKAppInviteDialogDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *friendsIds;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [self loadFacebookFriends];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(touchedLogoutBarButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriendsButtonTouched:)];
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *friendURI = self.friendsIds[indexPath.row];
    
    BXUContactNameLabel *nameLabel = (BXUContactNameLabel*)[cell viewWithTag:1];
    BXUContactAvatarImageView *avatarImageView = (BXUContactAvatarImageView*)[cell viewWithTag:2];
    
    Bit6Address *address = [Bit6Address addressWithURI:friendURI];
    nameLabel.address = address;
    avatarImageView.address = address;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *friendId = self.friendsIds[indexPath.row];
    
    Bit6Address *address = [Bit6Address addressWithFacebookId:friendId];
    
    [Bit6 startCallTo:address streams:Bit6CallStreams_Audio|Bit6CallStreams_Video];
}

#pragma mark - Facebook

- (void) loadFacebookFriends
{
    __weak FriendsViewController *conv = self;
    FBSDKGraphRequest *graph = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends"
                                                                 parameters:@{@"fields":@"name,first_name,last_name,id"}
                                                                 HTTPMethod:@"GET"];
    
    [graph startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *result, NSError *error) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:result.count];
        
        NSArray* friends = result[@"data"];
        NSMutableDictionary *dataSource = [NSMutableDictionary dictionaryWithCapacity:friends.count];
        
        for (NSDictionary* friend in friends) {
            //getting the URI
            NSString *uri = [Bit6Address addressWithFacebookId:friend[@"id"]].uri;
            //getting the contact picture
            NSString *avatarURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",friend[@"id"]];
            
            [array addObject:uri];
            
            //creating the Bit6UI contact
            dataSource[uri] = [[DemoContact alloc] initWithURI:uri name:[NSString stringWithFormat:@"%@ %@",friend[@"first_name"],friend[@"last_name"]] avatarURLString:avatarURLString];
        }
        
        conv.friendsIds = array;
        
        //setting the contacts in Bit6
        DemoContactSource *contactsSource = [DemoContactSource new];
        contactsSource.dataSource = dataSource;
        [BXU setContactSource:contactsSource];
        
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
