//
//  MakeCallViewController.m
//  CallDemo
//
//  Created by Carlos Thurber Boaventura on 06/13/14.
//  Copyright (c) 2014 Voxofon. All rights reserved.
//

#import "MakeCallViewController.h"

@interface MakeCallViewController ()

@property (weak, nonatomic) IBOutlet UITextField *destinationUsernameTextField;

@end

@implementation MakeCallViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",[Bit6Session userIdentity].displayName];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)touchedLogoutBarButton:(id)sender {
    [Bit6Session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)touchedAudioCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    if ([username length] > 0) {
        Bit6Address *address = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME value:username];
        [Bit6 startCallToAddress:address hasVideo:NO];
    }
}

- (IBAction)touchedVideoCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    if ([username length] > 0) {
        Bit6Address *address = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME value:username];
        [Bit6 startCallToAddress:address hasVideo:YES];
    }
}

@end
