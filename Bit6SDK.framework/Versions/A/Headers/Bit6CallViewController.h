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

/*! Reference to the <Bit6CallController> to work with. */
@property (nonatomic, strong, readonly) Bit6CallController *callController;

/*! Used if you need to force a call to <updateLayoutForRemoteVideoView:localVideoView:remoteVideoAspectRatio:localVideoAspectRatio:>. */
- (void)setNeedsUpdateVideoViewLayout;

///---------------------------------------------------------------------------------------
/// @name ￼Methods to extend
///---------------------------------------------------------------------------------------

/*! Called in the Main Thread when the UI controls should be updated. For example when the "mute" property changed this method will be called to allow updating the UI accordingly. The default implementation does nothing. */
- (void)refreshControlsView;

/*! Called in the Main Thread when the status of the call changes. The default implementation does nothing. */
- (void)callStateChangedNotification;

/*! Called in the Main Thread each second to allow the refresh of a timer UILabel. The default implementation does nothing. */
- (void)secondsChangedNotification;

/*! Called in the Main Thread to customize the frames for the video feeds. You can call <setNeedsUpdateVideoViewLayout> at any time to force a refresh of the frames. 
  @param remoteVideoView the UIView reference to the remote video feed
  @param localVideoView the UIView reference to the local video feed
  @param remoteVideoAspectRatio the aspect ratio to use for the remote video feed
  @param localVideoAspectRatio the aspect ratio to use for the local video feed
 */
- (void)updateLayoutForRemoteVideoView:(UIView*)remoteVideoView localVideoView:(UIView*)localVideoView remoteVideoAspectRatio:(CGSize)remoteVideoAspectRatio localVideoAspectRatio:(CGSize)localVideoAspectRatio;

@end
