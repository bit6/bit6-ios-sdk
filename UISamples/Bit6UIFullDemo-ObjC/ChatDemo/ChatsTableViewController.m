//
//  ChatsViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 04/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ChatsTableViewController.h"
#import "ConversationDetailsTableViewController.h"

@interface ChatsTableViewController () <BXULocationViewControllerDelegate, BXUImageViewControllerDelegate>

@end

@implementation ChatsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(showDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *detailButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems = @[detailButton, self.callButtonItem];
}

#pragma mark - BXUMessageTableViewDelegate

- (void)didSelectImageMessage:(nonnull Bit6Message*)message
{
    BXUImageViewController *imageVC = [BXUImageViewController new];
    imageVC.delegate = self;
    [imageVC setMessage:message];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imageVC];
    navController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
    if (self.navigationController.navigationBar.barTintColor) {
        navController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    }
    if (self.navigationController.navigationBar.titleTextAttributes) {
        navController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
    }
    if (self.navigationController.navigationBar.tintColor) {
        navController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    
    navController.navigationBar.translucent = NO;
    navController.toolbar.translucent = NO;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didSelectVideoMessage:(nonnull Bit6Message*)message
{
    [Bit6 playVideoFromMessage:message viewController:self.navigationController];
}

- (void)didSelectLocationMessage:(nonnull Bit6Message*)message
{
    BXULocationViewController *locationVC = [BXULocationViewController new];
    locationVC.delegate = self;
    locationVC.coordinate = message.location;
    
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:2];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps-x-callback://"]]) {
        [actions addObject:@"Google Maps"];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        [actions addObject:@"Waze"];
    }
    locationVC.actions = actions;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:locationVC];
    navController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
    if (self.navigationController.navigationBar.barTintColor) {
        navController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    }
    if (self.navigationController.navigationBar.titleTextAttributes) {
        navController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
    }
    if (self.navigationController.navigationBar.tintColor) {
        navController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    
    navController.navigationBar.translucent = NO;
    navController.toolbar.translucent = NO;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - BXULocationViewControllerDelegate

- (void)dismissLocationViewController:(nonnull BXULocationViewController*)locationViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectLocationAction:(nonnull NSString*)action coordinate:(CLLocationCoordinate2D)coordinate
{
    if ([action isEqualToString:@"Google Maps"]) {
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps-x-callback://?q=%f,%f&zoom=14&x-success=bit6fulldemo://&x-source=Bit6Demo", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else if ([action isEqualToString:@"Waze"]) {
        NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

#pragma mark - BXUImageViewControllerDelegate

- (void)dismissImageViewController:(BXUImageViewController *)imageViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void) showDetailInfo
{
    [self performSegueWithIdentifier:@"showDetails" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        ConversationDetailsTableViewController *obj = segue.destinationViewController;
        obj.conversation = [Bit6Conversation conversationWithAddress:self.address];
    }
}

@end
