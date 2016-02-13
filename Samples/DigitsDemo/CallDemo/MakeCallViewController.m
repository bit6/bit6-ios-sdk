//
//  MakeCallViewController.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 06/13/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "MakeCallViewController.h"

@interface MakeCallViewController ()

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
    NSString *phone = self.phoneNumberTextField.text;
    Bit6Address *address = [Bit6Address addressWithPhone:phone];
    
    Bit6CallController *callController = [Bit6 createCallTo:address streams:Bit6CallStreams_Audio];
    [self startCallToCalController:callController];
}

- (IBAction)touchedVideoCallButton:(id)sender {
    NSString *phone = self.phoneNumberTextField.text;
    Bit6Address *address = [Bit6Address addressWithPhone:phone];
    
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
        //trying to reuse the previous viewController
        Bit6CallViewController *callViewController = [Bit6 callViewController];
        
        if (!callViewController) {
            //create the default in-call UIViewController
            callViewController = [Bit6CallViewController createDefaultCallViewController];
            
            //use a custom in-call UIViewController
            //callViewController = [[MyCallViewController alloc] init];
        }
        
        //set the call to the viewController
        [callViewController addCallController:callController];
        
        //start the call
        [callController start];
        
        //present the viewController
        [Bit6 presentCallViewController:callViewController];
    }
    else {
        NSLog(@"Call Failed");
    }
}

@end
