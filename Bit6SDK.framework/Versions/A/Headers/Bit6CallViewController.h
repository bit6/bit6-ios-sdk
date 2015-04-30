//
//  Bit6CallViewController.h
//  Bit6
//
//  Created by Carlos Thurber on 01/08/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bit6CallController.h"

/*! UIViewController to extend to use during a call. */
@interface Bit6CallViewController : UIViewController

/*! Creates a default view controller to use during a call.
 @return view controller to use during a call.
 */
+ (Bit6CallViewController*) createDefaultCallViewController;

/*! Used if you need to force a call to <updateLayoutForRemoteVideoView:localVideoView:remoteVideoAspectRatio:localVideoAspectRatio:>. */
- (void)setNeedsUpdateVideoViewLayout;

///---------------------------------------------------------------------------------------
/// @name ￼Callbacks
///---------------------------------------------------------------------------------------

/*! Called in the Main Thread when the UI controls should be updated. For example when the "mute" property changed this method will be called to allow updating the UI accordingly. The default implementation does nothing. */
- (void)refreshControlsView;

/*! Called in the Main Thread when the status of the call changes. The default implementation does nothing. 
 @param callController <BitCallController> object which state has changed.
 */
- (void)callStateChangedNotificationForCallController:(Bit6CallController*)callController;

/*! Called in the Main Thread each second to allow the refresh of a timer UILabel. The default implementation does nothing. 
 @param callController <BitCallController> object which 'seconds' property has changed.
 */
- (void)secondsChangedNotificationForCallController:(Bit6CallController*)callController;

/*! Called in the Main Thread to customize the frames for the video feeds. You can call <setNeedsUpdateVideoViewLayout> at any time to force a refresh of the frames. 
  @param videoFeedViews the <Bit6VideoFeedView> references to the video feed.
 */
- (void)updateLayoutForVideoFeedViews:(NSArray*)videoFeedViews;

@end

/*! UIView to render a video feed during a call. */
@interface Bit6VideoFeedView : UIView

/*! Yes is the view is rendering the local video feed. */
@property (nonatomic, readonly) BOOL isLocal;

@end