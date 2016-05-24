//
//  NotificationBanner.h
//  NotificationAlertBanner
//
//  Created by Carlos Thurber on 02/15/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UIView* _Nonnull (^BXUContentViewGenerator) (CGRect incomingCallPromptFrame);

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

/*! Unavailable init. Use [BXUIncomingCallPrompt sharedInstance] instead.
 @return a new instance of the class.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/*! Returns the singleton BXUIncomingCallPrompt instance
 @return singleton BXUIncomingCallPrompt instance
 */
+ (nonnull BXUIncomingCallPrompt *)sharedInstance;

/*! Set a view to be shown at the center of the BXUIncomingCallPrompt view.
 @param contentView view to be shown in the BXUIncomingCallPrompt.
 @note Deprecated: Please use +[BXUIncomingCallPrompt setContentViewGenerator:] instead
 */
- (void)setContentView:(nullable UIView*)contentView __attribute__((deprecated("Please use -[BXUIncomingCallPrompt setContentViewGenerator:] instead")));

/*! Set a block to generate the view to be shown at the center of the BXUIncomingCallPrompt view.
 @param contentViewGenerator block to generate the view to be shown in the BXUIncomingCallPrompt.
 */
- (void)setContentViewGenerator:(nonnull BXUContentViewGenerator)contentViewGenerator;

/*! Action to be used to reject a call */
- (void)reject;

/*! Action to be used to answer an audio call */
- (void)answerAudio;

/*! Action to be used to answer an video call */
- (void)answerVideo;

/*! Action to be used to answer an data call */
- (void)answerData;

@end
