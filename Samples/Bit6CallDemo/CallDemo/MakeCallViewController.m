//
//  MakeCallViewController.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 06/13/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "MakeCallViewController.h"

@interface MakeCallViewController ()

@property (weak, nonatomic) IBOutlet UITextField *destinationUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

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
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    if (![Bit6 startCallToAddress:address hasVideo:NO]){
        NSLog(@"Call Failed");
    }
}

- (IBAction)touchedVideoCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    if (![Bit6 startCallToAddress:address hasVideo:YES]){
        NSLog(@"Call Failed");
    }
}

- (IBAction)touchedDialButton:(id)sender {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if (![Bit6 startCallToPhoneNumber:phoneNumber]){
        NSLog(@"Call Failed");
    }
}

@end
