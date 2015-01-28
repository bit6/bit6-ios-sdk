//
//  AppDelegate.m
//  FBVideoCalls
//
//  Created by Carlos Thurber on 12/19/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate (){
    Bit6CallController *_callController;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedIncomingCallNotification:) name:Bit6IncomingCallNotification object:nil];
    
    #warning Remember to set your api key
    [Bit6 startWithApiKey:@"your_api_key" pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT launchingWithOptions:launchOptions];
    
    #warning You need to set the FacebookAppID string on the info.plist file and add a URL Type as this fb[yourFacebookAppId] as explained in https://developers.facebook.com/docs/ios/getting-started/?locale=es_LA#configure

    
    return YES;
}

#pragma mark - Calls

- (void) receivedIncomingCallNotification:(NSNotification*)notification
{
    Bit6CallController *callController = [Bit6 callControllerFromIncomingCallNotification:notification];
    
    if ([Bit6 currentCallController]) {
        //there's a call on the way
        [callController declineCall];
    }
    else {
        _callController = callController;
        
        NSString *msg = notification.userInfo[@"aps"][@"alert"];
        _callController.other = [msg stringByReplacingOccurrencesOfString:@" is calling..." withString:@""];
        
        [Bit6.audioPlayer stopPlayingAudioFile];
        if ([notification.userInfo[@"answered"]boolValue]) {
            [self didBecomeActive:nil];
        }
        else {
            if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
                AudioServicesPlaySystemSound(1007);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Answer", nil];
                [alert show];
            }
            else {
                [self didBecomeActive:nil];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    Bit6CallController *callController = _callController;
    _callController = nil;
    
    if (buttonIndex==alertView.cancelButtonIndex) {
        [callController declineCall];
    }
    else {
        [self answerCall:callController];
    }
}

- (void) answerCall:(Bit6CallController*)callController
{
    if (callController) {
        [callController connectToViewController:nil completion:^(UIViewController *viewController, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateChangedNotification:) name:Bit6CallStateChangedNotification object:callController];
                [[[[UIApplication sharedApplication] windows][0] rootViewController] presentViewController:viewController animated:YES completion:nil];
            }
        }];
    }
}

- (void)didBecomeActive:(UIApplication *)application
{
    Bit6CallController *callController = _callController;
    _callController = nil;
    
    if (callController) {
        [self answerCall:callController];
    }
}

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

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
