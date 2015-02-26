//
//  AppDelegate.m
//  Bit6CallDemo
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MyCallViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) Bit6CallController *callController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    #warning Remember to set your api key
    [Bit6 startWithApiKey:@"your_api_key" pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT launchingWithOptions:launchOptions];
    
    return YES;
}

#pragma mark - Calls

/*
//use a custom in-call UIViewController
- (Bit6CallViewController*) inCallViewController
{
    MyCallViewController *callVC = [[MyCallViewController alloc] init];
    return callVC;
}
*/
 
/*
 //customize in-app incoming call banner notification
- (UIView*) incomingCallNotificationBannerContentView
{
    int numberOfLinesInMSG = 1;
    CGFloat padding = 10.0f;
    CGFloat separation = 3.0f;
    CGFloat titleHeight = 19.0f;
    CGFloat messageHeight = 17*numberOfLinesInMSG+5*(numberOfLinesInMSG-1);
    CGFloat buttonsAreaHeight = 60.0f;
    CGFloat height = padding*2+titleHeight+separation+messageHeight+buttonsAreaHeight;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height = height;
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType hasPrefix:@"iPad"]){
        CGFloat width = 450;
        frame.origin.x = (frame.size.width-width)/2.0;
        frame.size.width = width;
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = [UIColor colorWithRed:47/255.0f green:49/255.0f blue:50/255.0f alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width - padding*2, titleHeight)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.tag = 15;
    [contentView addSubview:titleLabel];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(titleLabel.frame)+separation, frame.size.width - padding*2, messageHeight)];
    msgLabel.font = [UIFont systemFontOfSize:15];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.tag = 16;
    msgLabel.numberOfLines = numberOfLinesInMSG;
    [contentView addSubview:msgLabel];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 17;
    button1.frame = CGRectMake(padding, CGRectGetMaxY(msgLabel.frame)+padding+6, (contentView.frame.size.width-padding*3)/2, buttonsAreaHeight-padding*2);
    [button1 setBackgroundImage:[Bit6Utils imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 10.0f;
    button1.clipsToBounds = YES;
    [button1 setTitle:@"Decline" forState:UIControlStateNormal];
    [contentView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 18;
    button2.frame = CGRectMake(CGRectGetMaxX(button1.frame)+padding, CGRectGetMaxY(msgLabel.frame)+padding+6, (contentView.frame.size.width-padding*3)/2, buttonsAreaHeight-padding*2);
    [button2 setBackgroundImage:[Bit6Utils imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 10.0f;
    button2.clipsToBounds = YES;
    [button2 setTitle:@"Answer" forState:UIControlStateNormal];
    [contentView addSubview:button2];
    
    return contentView;
}
*/

#pragma mark - Handling Call Full Flow

/*
//implement if you want to handle the entire incoming call flow
- (void) receivedIncomingCallNotification:(NSNotification*)notification
{
    //create the callController
    Bit6CallController *callController = [Bit6 callControllerFromIncomingCallNotification:notification];
    
    //if there's a call on the way we decline this one
    if ([Bit6 currentCallController] || self.callController) {
        [callController declineCall];
    }
    else {
        //register to listen changes in call status
        [callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
        
        //get the caller name
        NSString *msg = callController.incomingCallAlert;
        callController.otherDisplayName = [msg stringByReplacingOccurrencesOfString:@" is calling..." withString:@""];
        
        //get the call type
        NSString *type = callController.hasVideo?@"Video":@"Audio";
        
        //show an incoming-call prompt
        NSString *message = [NSString stringWithFormat:@"Incoming %@ Call from: %@", type, callController.otherDisplayName];
        callController.incomingCallAlert = message;
        
        //the call was answered by taping the push notification
        if (callController.incomingCallAnswered) {
            [self answerCall:callController];
        }
        else {
            //retain the callController while we show an incoming-call prompt
            self.callController = callController;
            
            //show an incoming-call prompt
            [Bit6.incomingCallNotificationBanner showBannerForCallController:callController answerHandler:^{
                Bit6CallController *callController = self.callController;
                self.callController = nil;
                [self answerCall:callController];
            } declineHandler:^{
                Bit6CallController *callController = self.callController;
                self.callController = nil;
                [callController removeObserver:self forKeyPath:@"callState"];
                [callController declineCall];
            }];
            
            //play the ringtone
            [callController startRingtone];
        }
    }
}

- (void) answerCall:(Bit6CallController*)callController
{
    //create the in-call UIViewController
    Bit6CallViewController *callVC = [self inCallViewController];
    
    //start the call
    [callController connectToViewController:callVC];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([object isKindOfClass:[Bit6CallController class]]) {
            if ([keyPath isEqualToString:@"callState"]) {
                [self callStateChangedNotification:object];
            }
        }
    });
}

- (void) callStateChangedNotification:(Bit6CallController*)callController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //it's a missed call: remove the observer, dismiss the incoming-call prompt and the viewController
        if (callController.callState == Bit6CallState_MISSED) {
            [callController removeObserver:self forKeyPath:@"callState"];
            self.callController = nil;
            [Bit6.incomingCallNotificationBanner dismiss];
            [Bit6 dismissCallController:callController];
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Missed Call from %@",callController.otherDisplayName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        //the call is starting: show the viewController
        else if (callController.callState == Bit6CallState_PROGRESS) {
            [Bit6 presentCallController:callController];
        }
        //the call ended: remove the observer and dismiss the viewController
        else if (callController.callState == Bit6CallState_END) {
            [callController removeObserver:self forKeyPath:@"callState"];
            [Bit6 dismissCallController:callController];
        }
        //the call ended with an error: remove the observer and dismiss the viewController
        else if (callController.callState == Bit6CallState_ERROR) {
            [callController removeObserver:self forKeyPath:@"callState"];
            [Bit6 dismissCallController:callController];
            [[[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:callController.error.localizedDescription?:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
}
 
*/

@end
