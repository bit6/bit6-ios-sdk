//
//  NotificationBanner.h
//  NotificationAlertBanner
//
//  Created by Carlos Thurber on 02/15/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bit6CallController.h"

/*! Used to show a nice and clean incoming call prompt that dim the entire screen while it's visible. This class is intented to be used as a singleton instance, please use Bit6IncomingCallPrompt.sharedInstance() */
@interface Bit6IncomingCallPrompt : NSObject

/*! Set a block of code to be executed on the Bit6IncomingCallPrompt.answerAudio() event.
 @param answerAudioHandler block of code to be executed.
 */
+ (void)setAnswerAudioHandler:(nullable void (^)(Bit6CallController* _Nonnull))answerAudioHandler;

/*! Set a block of code to be executed on the Bit6IncomingCallPrompt.answerVideo() event.
 @param answerVideoHandler block of code to be executed.
 */
+ (void)setAnswerVideoHandler:(nullable void (^)(Bit6CallController* _Nonnull))answerVideoHandler;

/*! Set a block of code to be executed on the Bit6IncomingCallPrompt.answerData() event.
 @param answerDataHandler block of code to be executed.
 */
+ (void)setAnswerDataHandler:(nullable void (^)(Bit6CallController* _Nonnull))answerDataHandler;

/*! Set a block of code to be executed on the Bit6IncomingCallPrompt.reject() event.
 @param rejectHandler block of code to be executed.
 */
+ (void)setRejectHandler:(nullable void (^)(Bit6CallController* _Nonnull))rejectHandler;

/*! Presents the Bit6IncomingCallPrompt.
 @param callController call to be linked to the prompt
 */
+ (void)showForCallController:(nonnull Bit6CallController*)callController;

/*! Dismiss the Bit6IncomingCallPrompt.
 */
+ (void)dismiss;

/*! Returns the call linked to the prompt
 @return callController linked to the prompt
 */
+ (nullable Bit6CallController*)callController;

///---------------------------------------------------------------------------------------
/// @name ￼ContentView Full Customization
///---------------------------------------------------------------------------------------

/*! Returns the singleton Bit6IncomingCallPrompt instance
 @return singleton Bit6IncomingCallPrompt instance
 */
+ (nonnull Bit6IncomingCallPrompt *)sharedInstance;

/*! Set a view to be shown at the center of the Bit6IncomingCallPrompt view.
 @param contentView view to be shown in the Bit6IncomingCallPrompt.
 */
- (void)setContentView:(nullable UIView*)contentView;

/*! Action to be used to reject a call
 */
- (void)reject;

/*! Action to be used to answer an audio call
 */
- (void)answerAudio;

/*! Action to be used to answer an video call
 */
- (void)answerVideo;

/*! Action to be used to answer an data call
 */
- (void)answerData;

@end
