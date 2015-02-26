//
//  NotificationBanner.h
//  NotificationAlertBanner
//
//  Created by Carlos Thurber on 02/15/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6CallController.h"

/*! Used to show a nice and clean incoming call prompt that slides down from the top of the screen. */
@interface Bit6IncomingCallNotificationBanner : NSObject

/*! Show the incoming call banner.
 @param callController call controller associated with the incoming call.
 @param answerHandler block to execute if the "answer" button is pressed
 @param declineHandler block to execute if the "decline" button is pressed
 */
- (void) showBannerForCallController:(Bit6CallController*)callController answerHandler:(void (^)())answerHandler declineHandler:(void (^)())declineHandler;

/*! Dismiss the incoming call banner. */
- (void) dismiss;

@end
