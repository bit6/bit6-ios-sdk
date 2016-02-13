//
//  AppDelegate.m
//  DataChannelDemo
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@import Bit6;

#warning Remember to set your api key
#define BIT6_API_KEY (@"BIT6_API_KEY")

@interface AppDelegate () <UISplitViewControllerDelegate, Bit6IncomingCallHandlerDelegate>

@property (nonatomic, strong) UISplitViewController *splitView;
@property (nonatomic, strong) MasterViewController *masterVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Bit6.incomingCallHandler.delegate = self;
    
    NSAssert(![BIT6_API_KEY isEqualToString:@"BIT6_API_KEY"], @"[Bit6 SDK]: Setup your Bit6 api key.");
    
    [Bit6 startWithApiKey:BIT6_API_KEY];
    
    self.splitView = (UISplitViewController*)self.window.rootViewController;
    self.splitView.minimumPrimaryColumnWidth = 400;
    self.splitView.maximumPrimaryColumnWidth = 400;
    self.splitView.delegate = self;
    
    UINavigationController *navController = self.splitView.viewControllers[0];
    self.masterVC = (MasterViewController*) navController.topViewController;
    
    return YES;
}

- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)svc
{
    return UISplitViewControllerDisplayModeAllVisible;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
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

#pragma mark -

//customize in-app incoming call prompt
- (nullable UIView*)incomingCallPromptContentViewForCallController:(nonnull Bit6CallController*)callController
{
    NSInteger numberOfStreams = (callController.hasRemoteAudio?1:0) + (callController.hasRemoteVideo?1:0) + (callController.hasRemoteData?1:0);
    NSInteger numberOfButtons = numberOfStreams > 0 ? (numberOfStreams + 1) : 2;
    
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
        SEL selector = callController.hasRemoteData?@selector(answerData):nil;
        [answerButton addTarget:[Bit6IncomingCallPrompt sharedInstance] action:selector forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:answerButton];
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
    
    //the call was answered by taping the push notification
    if (callController.incomingCallAnswered) {
        callController.localStreams = callController.remoteStreams;
        [self answerCall:callController];
    }
    else {
        //show an incoming-call prompt
        [Bit6IncomingCallPrompt sharedInstance].contentView = [self incomingCallPromptContentViewForCallController:callController];
        
        Bit6IncomingCallPrompt.answerDataHandler = ^(Bit6CallController* callController){
            [Bit6IncomingCallPrompt dismiss];
            callController.localStreams = Bit6CallStreams_Data;
            [self answerCall:callController];
        };
        Bit6IncomingCallPrompt.rejectHandler = ^(Bit6CallController* callController){
            [Bit6IncomingCallPrompt dismiss];
            [callController declineCall];
        };
        
        [Bit6IncomingCallPrompt showForCallController:callController];
        
        //play the ringtone
        [callController playRingtone];
    }
}

- (void) answerCall:(Bit6CallController*)callController
{
    //register to listen changes in call status
    [callController addObserver:self.masterVC forKeyPath:@"callState" options:NSKeyValueObservingOptionOld context:NULL];
    
    [callController start];
    self.masterVC.callController = callController;
}

@end
