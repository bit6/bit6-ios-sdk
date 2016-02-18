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

#warning Remember to set your api key
#define BIT6_API_KEY (@"BIT6_API_KEY")

@interface AppDelegate () <Bit6IncomingCallHandlerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    
    //uncomment to handle the incoming call
    //Bit6.incomingCallHandler.delegate = self;
    
    [Bit6 startWithApiKey:BIT6_API_KEY];
    
    NSDictionary *remoteNotificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [Bit6.pushNotification didReceiveRemoteNotification:remoteNotificationPayload];
    }
    
    return YES;
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [Bit6.pushNotification handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [Bit6.pushNotification didReceiveRemoteNotification:userInfo];
}

- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [Bit6.pushNotification didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [Bit6.pushNotification didFailToRegisterForRemoteNotificationsWithError:error];
}

#pragma mark - Bit6IncomingCallHandlerDelegate

/*
//use a custom in-call UIViewController
- (nonnull Bit6CallViewController*)inCallViewController
{
    //if there's another call on the way, we are going to merge the callcontrollers into one viewcontroller
    if ([Bit6 callViewController]) {
        return [Bit6 callViewController];
    }
    else {
        //custom view controller
        return [[MyCallViewController alloc] init];
        
        //default view controller
        //return [Bit6CallViewController createDefaultCallViewController];
    }
}

 //customize in-app incoming call prompt
- (nullable UIView*)incomingCallPromptContentViewForCallController:(nonnull Bit6CallController*)callController
{
    NSInteger numberOfStreams = (callController.hasRemoteAudio?1:0) + (callController.hasRemoteVideo?1:0) + (callController.hasRemoteData?1:0);
    NSInteger numberOfButtons = numberOfStreams == 3 ? 3 : numberOfStreams > 0 ? (numberOfStreams + 1) : 2;
    
    NSString *title = callController.incomingCallAlert;
    
    CGFloat WIDTH = 290;
    CGSize size = CGSizeMake(WIDTH,130);
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x = (frame.size.width-size.width)/2;
    frame.origin.y = (frame.size.height-size.height)/2;
    frame.size.width = size.width;
    frame.size.height = size.height;
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.layer.cornerRadius = 10.0;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor colorWithRed:251/255.0f green:249/255.0f blue:224/255.0f alpha:1.0];
    
    CGFloat labelMargin = 13;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelMargin, labelMargin, size.width-labelMargin*2, 20)];
    titleLabel.textColor = [UIColor colorWithRed:132/255.0f green:105/255.0f blue:56/255.0f alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = title;
    [contentView addSubview:titleLabel];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    frame = titleLabel.frame;
    frame.origin.y = CGRectGetMaxY(frame)+13;
    msgLabel.frame = frame;
    msgLabel.textColor = [UIColor colorWithRed:132/255.0f green:105/255.0f blue:56/255.0f alpha:1.0];
    msgLabel.font = [UIFont systemFontOfSize:15.0];
    msgLabel.text = @"Do you dare to answer this call?";
    [contentView addSubview:msgLabel];
    
    CGFloat buttonSeparationX = 12.5;
    CGFloat buttonWidth = (WIDTH - buttonSeparationX*(numberOfButtons+1))/numberOfButtons;
    CGFloat nextButtonX = buttonSeparationX;
    CGFloat nextButtonY = CGRectGetMaxY(msgLabel.frame)+14;
    
    //in this case we only show answer and reject buttons
    if (numberOfStreams < 2) {
        UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        answerButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
        UIColor *color = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:179/255.0f alpha:1.0];
        UIImage *backgroundImage = [Bit6Utils imageWithColor:color];
        [answerButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        answerButton.layer.cornerRadius = 10.0f;
        answerButton.layer.masksToBounds = YES;
        [answerButton setTitle:@"Answer" forState:UIControlStateNormal];
        SEL selector = callController.hasRemoteAudio?@selector(answerAudio):(callController.hasRemoteVideo?@selector(answerVideo):callController.hasRemoteData?@selector(answerData):nil);
        [answerButton addTarget:[Bit6IncomingCallPrompt sharedInstance] action:selector forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:answerButton];
    }
    //in this case we show two buttons
    else {
        //AUDIO BUTTON
        UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        audioButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
        UIColor *color = [UIColor colorWithRed:86/255.0f green:188/255.0f blue:221/255.0f alpha:1.0];
        UIImage *backgroundImage = [Bit6Utils imageWithColor:color];
        [audioButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        audioButton.layer.cornerRadius = 10.0f;
        audioButton.layer.masksToBounds = YES;
        [audioButton setTitle:@"Audio" forState:UIControlStateNormal];
        [audioButton addTarget:[Bit6IncomingCallPrompt sharedInstance] action:@selector(answerAudio) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:audioButton];
        
        //VIDEO BUTTON
        if (callController.hasRemoteVideo) {
            nextButtonX = (nextButtonX + buttonWidth) + buttonSeparationX;
            UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            videoButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
            color = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:179/255.0f alpha:1.0];
            backgroundImage = [Bit6Utils imageWithColor:color];
            [videoButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
            videoButton.layer.cornerRadius = 10.0f;
            videoButton.layer.masksToBounds = YES;
            [videoButton setTitle:@"Video" forState:UIControlStateNormal];
            [videoButton addTarget:[Bit6IncomingCallPrompt sharedInstance] action:@selector(answerVideo) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:videoButton];
        }
    }
    
    //REJECT BUTTON
    nextButtonX = (nextButtonX + buttonWidth) + buttonSeparationX;
    UIButton *rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rejectButton.frame = CGRectMake(nextButtonX, nextButtonY, buttonWidth, 40);
    UIColor *color = [UIColor colorWithRed:206/255.0f green:68/255.0f blue:68/255.0f alpha:1.0];
    UIImage *backgroundImage = [Bit6Utils imageWithColor:color];
    [rejectButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    rejectButton.layer.cornerRadius = 10.0f;
    rejectButton.layer.masksToBounds = YES;
    [rejectButton setTitle:@"Reject" forState:UIControlStateNormal];
    [rejectButton addTarget:[Bit6IncomingCallPrompt sharedInstance] action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rejectButton];
    
    return contentView;
}

//implement if you want to handle the entire incoming call flow
- (void)receivedIncomingCall:(nonnull Bit6CallController*)callController
{
    //get the caller name
    NSString *msg = callController.incomingCallAlert;
    callController.otherDisplayName = [msg stringByReplacingOccurrencesOfString:@" is calling..." withString:@""];
    
    callController.incomingCallAlert = [NSString stringWithFormat:@"%@ is %@calling...", callController.otherDisplayName, callController.hasRemoteData?@"data ":(callController.hasRemoteVideo?@"video ":@"")];
    
    //register to listen changes in call status
    [callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
    
    //the call was answered by taping the push notification
    if (callController.incomingCallAnswered) {
        callController.localStreams = callController.remoteStreams;
        [self answerCall:callController];
    }
    else {
        //show an incoming-call prompt
        [Bit6IncomingCallPrompt sharedInstance].contentView = [self incomingCallPromptContentViewForCallController:callController];
        
        Bit6IncomingCallPrompt.answerAudioHandler = ^(Bit6CallController* callController){
            [Bit6IncomingCallPrompt dismiss];
            callController.localStreams = Bit6CallStreams_Audio;
            [self answerCall:callController];
        };
        Bit6IncomingCallPrompt.answerVideoHandler = ^(Bit6CallController* callController){
            [Bit6IncomingCallPrompt dismiss];
            callController.localStreams = Bit6CallStreams_Audio|Bit6CallStreams_Video;
            [self answerCall:callController];
        };
        Bit6IncomingCallPrompt.rejectHandler = ^(Bit6CallController* callController){
            [Bit6IncomingCallPrompt dismiss];
            [callController removeObserver:self forKeyPath:@"callState"];
            [callController declineCall];
        };
        
        [Bit6IncomingCallPrompt showForCallController:callController];
        
        //play the ringtone
        [callController playRingtone];
    }
}

- (void) answerCall:(Bit6CallController*)callController
{
    Bit6CallViewController *callViewController = [self inCallViewController];
    [callViewController addCallController:callController];
    [callController start];
    
    UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
    if (vc.presentedViewController) {
        [self presentCallViewController:callViewController];
    }
    else {
        [Bit6 presentCallViewController:callViewController];
    }
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
    //the call ended: remove the observer
    if (callController.callState == Bit6CallState_MISSED || callController.callState == Bit6CallState_END || callController.callState == Bit6CallState_ERROR) {
        [callController removeObserver:self forKeyPath:@"callState"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //it's a missed call: dismiss the incoming-call prompt
        if (callController.callState == Bit6CallState_MISSED) {
            [Bit6IncomingCallPrompt dismiss];
            
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Missed Call from %@",callController.otherDisplayName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        //the call ended
        else if (callController.callState == Bit6CallState_END) {
            
#warning uncomment if presented with [self presentCallViewController:callViewController];
//            [self dismissCallViewController];
            
        }
        //the call ended with an error
        else if (callController.callState == Bit6CallState_ERROR) {
            
#warning uncomment if presented with [self presentCallViewController:callViewController];
//            [self dismissCallViewController];
            
            [[[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:callController.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
}

- (void)presentCallViewController:(Bit6CallViewController*)callViewController
{
#warning Add your code to present the callViewController
    
}

- (void)dismissCallViewController
{
#warning Add your code to dismiss the callViewController
}
*/

@end
