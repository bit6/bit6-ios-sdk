//
//  Bit6CallViewController.h
//  Bit6
//
//  Created by Carlos Thurber on 01/08/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bit6CallController.h"
#import "Bit6VideoFeedView.h"

NS_ASSUME_NONNULL_BEGIN

/*! UIViewController to use during a call. This class should be extended. Only one object of this class or its subclasses should be kept in memory. */
@interface Bit6CallViewController : UIViewController <Bit6CallControllerDelegate>

/*! View to render the local video feed. */
@property (nullable, nonatomic, strong, readonly) Bit6VideoFeedView* localVideoView;

/*! List of calls linked to this viewController. */
@property (nonatomic, copy, readonly) NSArray<Bit6CallController*>* callControllers;

/*! Used if you need to force a call to <updateLayoutForRemoteVideoView:localVideoView:remoteVideoAspectRatio:localVideoAspectRatio:>. */
- (void)setNeedsUpdateVideoViewLayout;

/*! Shows the callViewController in a new UIWindow using a "slide up from the bottom of the screen" transition. */
- (void)show;

///---------------------------------------------------------------------------------------
/// @name ￼Callbacks
///---------------------------------------------------------------------------------------

/*! Needs to be implemented in the subclass to return a new view controller for the call.
 @param callController <BitCallController> object to build the UI around.
 @return an UIViewController to use for the call. */
+ (Bit6CallViewController*)createForCall:(Bit6CallController*)callController;

/*! Called in the Main Thread when the UI controls should be updated. For example when the "mute" property changed this method will be called to allow updating the UI accordingly. The default implementation does nothing. */
- (void)refreshControlsView;

/*! Called in the Main Thread when the status of the call changes. Needs to call super if implemented.
 @param callController <BitCallController> object which state has changed.
 @param state new state for the call.
 */
- (void)callController:(Bit6CallController*)callController callDidChangeToState:(Bit6CallState)state;

/*! Called in the Main Thread each second to allow the refresh of a timer UI. Needs to call super if implemented.
 @param callController <BitCallController> object which 'seconds' property has changed.
 */
- (void)secondsDidChangeForCallController:(Bit6CallController*)callController;

/*! Called in the Main Thread to customize the frames for the video feeds. You can call <setNeedsUpdateVideoViewLayout> at any time to force a refresh of the frames. 
  @param videoFeedViews the <Bit6VideoFeedView> references to the video feed.
 */
- (void)updateLayoutForVideoFeedViews:(NSArray<Bit6VideoFeedView*>*)videoFeedViews;

/*! Called in the Main Thread when the local video feed will be interrupted. Needs to call super if implemented.
 @param callController <BitCallController> object referring to the call.
 @param reason reason for the interruption as a AVCaptureSessionInterruptionReason value. Only AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps is supported at the moment.
 */
- (void)callController:(Bit6CallController*)callController localVideoFeedInterruptedBecause:(int)reason;

/*! Called in the Main Thread when the local video feed interruption has ended. Needs to call super if implemented.
 @param callController <BitCallController> object referring to the call.
 */
- (void)localVideoFeedInterruptionEndedForCallController:(Bit6CallController*)callController;

@end

NS_ASSUME_NONNULL_END
