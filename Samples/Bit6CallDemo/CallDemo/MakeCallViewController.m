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
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.userIdentity.displayName];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)touchedLogoutBarButton:(id)sender {
    [Bit6.session logoutWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        if (! error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)touchedAudioCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    
    Bit6CallController *callController = [Bit6 startCallToAddress:address hasAudio:YES hasVideo:NO hasData:NO];
    [self startCallToCalController:callController];
}

- (IBAction)touchedVideoCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    
    Bit6CallController *callController = [Bit6 startCallToAddress:address hasAudio:YES hasVideo:YES hasData:NO];
    [self startCallToCalController:callController];
}

- (IBAction)touchedDialButton:(id)sender {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    Bit6CallController *callController = [Bit6 startCallToPhoneNumber:phoneNumber];
    [self startCallToCalController:callController];
}

- (void) startCallToCalController:(Bit6CallController*)callController
{
    if (callController) {
        //we listen to call state changes
        [callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
        
        //create the default in-call UIViewController
        Bit6CallViewController *callVC = [Bit6CallViewController createDefaultCallViewController];
        
        //use a custom in-call UIViewController
        //MyCallViewController *callVC = [[MyCallViewController alloc] init];
        
        //start the call
        [callController connectToViewController:callVC];
    }
    else {
        NSLog(@"Call Failed");
    }
}

#pragma mark - Calls

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[Bit6CallController class]]) {
        if ([keyPath isEqualToString:@"callState"]) {
            [self callStateChangedNotification:object];
        }
    }
}

- (void) callStateChangedNotification:(Bit6CallController*)callController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //the call is starting: show the viewController
        if (callController.callState == Bit6CallState_PROGRESS) {
            [Bit6 presentCallViewController];
        }
        //the call ended: remove the observer and dismiss the viewController
        else if (callController.callState == Bit6CallState_END) {
            [callController removeObserver:self forKeyPath:@"callState"];
        }
        //the call ended with an error: remove the observer and dismiss the viewController
        else if (callController.callState == Bit6CallState_ERROR) {
            [callController removeObserver:self forKeyPath:@"callState"];
            [[[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:callController.error.localizedDescription?:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
}

@end
