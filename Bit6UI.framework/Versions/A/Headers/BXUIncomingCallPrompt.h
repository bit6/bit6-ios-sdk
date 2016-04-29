//
//  NotificationBanner.h
//  NotificationAlertBanner
//
//  Created by Carlos Thurber on 02/15/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*! Used to show a nice and clean incoming call prompt that dim the entire screen while it's visible. This class is intented to be used as a singleton instance, please use Bit6IncomingCallPrompt.sharedInstance() when necessary. */
@interface BXUIncomingCallPrompt : NSObject

/*! Presents the BXUIncomingCallPrompt.
 @param callController call to be linked to the prompt
 */
+ (void)showForCallController:(nonnull Bit6CallController*)callController;

/*! Dismiss the BXUIncomingCallPrompt. */
+ (void)dismiss;

/*! Returns the call linked to the prompt
 @return callController linked to the prompt
 */
+ (nullable Bit6CallController*)callController;

///---------------------------------------------------------------------------------------
/// @name ￼ContentView Full Customization
///---------------------------------------------------------------------------------------

/*! Returns the singleton BXUIncomingCallPrompt instance
 @return singleton BXUIncomingCallPrompt instance
 */
+ (nonnull BXUIncomingCallPrompt *)sharedInstance;

/*! Set a view to be shown at the center of the BXUIncomingCallPrompt view.
 @param contentView view to be shown in the BXUIncomingCallPrompt.
 */
- (void)setContentView:(nullable UIView*)contentView;

/*! Action to be used to reject a call */
- (void)reject;

/*! Action to be used to answer an audio call */
- (void)answerAudio;

/*! Action to be used to answer an video call */
- (void)answerVideo;

/*! Action to be used to answer an data call */
- (void)answerData;

@end
