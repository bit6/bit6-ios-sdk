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
    
    Bit6CallController *callController = [Bit6 startCallToAddress:address hasVideo:NO];
    [self startCallToCalController:callController];
}

- (IBAction)touchedVideoCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:username];
    
    Bit6CallController *callController = [Bit6 startCallToAddress:address hasVideo:YES];
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
        //Default ViewController
        [callController connectToViewController:nil completion:^(UIViewController *viewController, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateChangedNotification:) name:Bit6CallStateChangedNotification object:callController];
                [[[[UIApplication sharedApplication] windows][0] rootViewController] presentViewController:viewController animated:YES completion:nil];
            }
        }];
        
        //Custom ViewController
        /*
        MyCallViewController *vc = [[MyCallViewController alloc] initWithCallController:callController];
        [callController connectToViewController:vc completion:^(UIViewController *viewController, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateChangedNotification:) name:Bit6CallStateChangedNotification object:callController];
                [[[[UIApplication sharedApplication] windows][0] rootViewController] presentViewController:viewController animated:YES completion:nil];
            }
        }];
        */
    }
    else {
        NSLog(@"Call Failed");
    }
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

@end
