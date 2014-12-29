//
//  FriendsViewController.m
//  FBVideoCalls
//
//  Created by Carlos Thurber on 12/19/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *friendsDict;
@property (strong, nonatomic) NSArray *friendsIds;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [self loadFacebookFriends];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(touchedLogoutBarButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(touchedInviteFriendsButtonTouched:)];
    
    [super viewDidLoad];
}

- (void)touchedLogoutBarButton:(id)sender {
    [Bit6Session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
    }];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *friendId = self.friendsIds[indexPath.row];
    NSString *name = self.friendsDict[friendId];
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_FACEBOOK value:friendId];
    
    Bit6CallController *callController = [Bit6 startCallToAddress:address hasVideo:YES];
    callController.other = name;
    
    [callController connectToViewController:nil completion:^(UIViewController *viewController, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateChangedNotification:) name:Bit6CallStateChangedNotification object:callController];
            [[[[UIApplication sharedApplication] windows][0] rootViewController] presentViewController:viewController animated:YES completion:nil];
        }
    }];
}

#pragma mark - Calls

- (void) callStateChangedNotification:(NSNotification*)notification
{
    Bit6CallController *callController = notification.object;
    
    if (callController.callState == Bit6CallState_END || callController.callState == Bit6CallState_ERROR) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Bit6CallStateChangedNotification object:callController];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[UIApplication sharedApplication] windows][0] rootViewController] dismissViewControllerAnimated:YES completion:nil];
            if (callController.callState == Bit6CallState_ERROR) {
                [[[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        });
    }
}

#pragma mark - Facebook

- (void) loadFacebookFriends
{
    __weak FriendsViewController *conv = self;
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,NSDictionary *result,NSError *error) {
                              
                              NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:result.count];
                              NSMutableArray *array = [NSMutableArray arrayWithCapacity:result.count];
                              
                              NSArray* friends = result[@"data"];
                              for (NSDictionary<FBGraphUser>* friend in friends) {
                                  [array addObject:friend.objectID];
                                  dict[friend.objectID] = friend.name;
                              }
                              
                              conv.friendsIds = array;
                              conv.friendsDict = dict;
                              
                              [conv.tableView reloadData];
                          }];
}

#pragma mark - Invite Friends

- (void) touchedInviteFriendsButtonTouched:(UIBarButtonItem*)sender
{
    NSMutableDictionary* params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Try FBVideoCalls", @"message",
     nil, @"to",
     nil];
    
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:nil
     title:nil
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Case A: Error launching the dialog or sending request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // Case B: User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSLog(@"User sent request.");
                 }
             }
         }
     }];
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

@end
