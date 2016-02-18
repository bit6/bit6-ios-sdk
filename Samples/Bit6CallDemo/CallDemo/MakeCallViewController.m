//
//  MakeCallViewController.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 06/13/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "MakeCallViewController.h"
#import "MyCallViewController.h"

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
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.activeIdentity.displayName];
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.activeIdentity.displayName];
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
    Bit6Address *address = [Bit6Address addressWithUsername:username];
    
    Bit6CallController *callController = [Bit6 createCallTo:address streams:Bit6CallStreams_Audio];
    [self startCallToCalController:callController];
}

- (IBAction)touchedVideoCallButton:(id)sender {
    NSString *username = self.destinationUsernameTextField.text;
    Bit6Address *address = [Bit6Address addressWithUsername:username];
    
    Bit6CallController *callController = [Bit6 createCallTo:address streams:Bit6CallStreams_Audio|Bit6CallStreams_Video];
    [self startCallToCalController:callController];
}

- (IBAction)touchedDialButton:(id)sender {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    Bit6CallController *callController = [Bit6 createCallToPhoneNumber:phoneNumber];
    [self startCallToCalController:callController];
}

- (void) startCallToCalController:(Bit6CallController*)callController
{
    if (callController) {
        //trying to reuse the previous viewController, or create a default one
        Bit6CallViewController *callViewController = [Bit6 callViewController] ?: [Bit6CallViewController createDefaultCallViewController];
        
        //trying to reuse the previous viewController, or create a custom one
        //Bit6CallViewController *callViewController = [Bit6 callViewController] ?: [[MyCallViewController alloc] init];
        
        //set the call to the viewController
        [callViewController addCallController:callController];
        
        //start the call
        [callController start];
        
        //present the viewController
        UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
        if (vc.presentedViewController) {
            [callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
            [self presentCallViewController:callViewController];
        }
        else {
            [Bit6 presentCallViewController:callViewController];
        }
    }
    else {
        NSLog(@"Call Failed");
    }
}

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
    if (callController.callState == Bit6CallState_END || callController.callState == Bit6CallState_ERROR) {
        [callController removeObserver:self forKeyPath:@"callState"];
        [self dismissCallViewController];
    }
}

- (void)presentCallViewController:(Bit6CallViewController*)callViewController
{
    [self presentViewController:callViewController animated:YES completion:nil];
}

- (void)dismissCallViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
