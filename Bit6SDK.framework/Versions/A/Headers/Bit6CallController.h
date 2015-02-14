//
//  Bit6CallController.h
//  Bit6
//
//  Created by Carlos Thurber on 12/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bit6Address.h"

/*! Call status for a <Bit6CallController>. */
typedef NS_ENUM(NSInteger, Bit6CallState) {
    /*! The call hasn't started. */
    Bit6CallState_NEW,
    /*! The call is starting. */
    Bit6CallState_PROGRESS,
    /*! The call has started. */
    Bit6CallState_ANSWER,
    /*! The call ended. */
    Bit6CallState_END,
    /*! The call ended with an error. */
    Bit6CallState_ERROR,
    /*! The call has been interrupted. */
    Bit6CallState_INTERRUPTED,
};

@protocol Bit6CallControllerDelegate;

/*! Bit6CallController represents an in-progress call. */
@interface Bit6CallController : NSObject

/*! Starts a call
 @param viewController a custom viewcontroller in which to start the call. Can be nil.
 @param completion block to call after the call is ready to start
 */
- (void) connectToViewController:(UIViewController<Bit6CallControllerDelegate>*)viewController completion:(void (^)(UIViewController *viewController, NSError *error))completion;
/*! Declines the call
 */
- (void) declineCall;

/*! Creates an UIView to display a video feed
 @param frame frame of the new UIView
 @param delegate the delegate to be notified of changes in video feed. See <Bit6CallControllerDelegate> Protocol Reference.
 */
+ (UIView*) createVideoTrackViewWithFrame:(CGRect)frame delegate:(id<Bit6CallControllerDelegate>)delegate;

///---------------------------------------------------------------------------------------
/// @name ￼Call Properties
///---------------------------------------------------------------------------------------

/*! Call status as a value of the <Bit6MessageStatus> enumeration. */
@property (nonatomic, readonly) Bit6CallState callState;
/*! Display name from the destination user */
@property (nonatomic, strong) NSString *other;
/*! The current call is a video call */
@property (nonatomic, readonly) BOOL hasVideo;
/*! The number of seconds the call has been going */
@property (nonatomic, readonly) NSUInteger seconds;
/*! The audio from the call is going through the speaker */
@property (nonatomic, readonly) BOOL speakerEnabled;
/*! The audio is muted for the current call */
@property (nonatomic, readonly) BOOL audioMuted;

///---------------------------------------------------------------------------------------
/// @name ￼Actions
///---------------------------------------------------------------------------------------

/*! Switch between the frontal and rear camera, if available. */
- (void) switchCamera;

/*! End the current call. */
- (void) hangup;

/*! Mute and unmute the audio in the current call. */
- (void) switchMuteAudio;

/*! Change the audio route from the default one to the speaker, and vice versa. */
- (void) switchSpeaker;

///---------------------------------------------------------------------------------------
/// @name ￼Ringtone
///---------------------------------------------------------------------------------------

/*! Play the ringtone defined in the incoming push notification payload. */
- (void) startRingtone;

@end

/*! The Bit6CallControllerDelegate protocol defines the methods a delegate of a <Bit6CallController> object should implement.
 */
@protocol Bit6CallControllerDelegate <NSObject>

/*! Called to get the local video feed UIView to use in the call
 @param callController <Bit6CallController> object of the call
 @return the UIView to show the local video feed
 */
- (UIView*)localVideoTrackViewForCallController:(Bit6CallController*)callController;

/*! Called to get the remote video feed UIView to use in the call
 @param callController <Bit6CallController> object of the call
 @return the UIView to show the remote video feed
 */
- (UIView*)remoteVideoTrackViewForCallController:(Bit6CallController*)callController;

/*! Called when the video feed UIView should changed its size
 @param videoView video feed UIView
 @param size new size of the video feed UIView
 */
- (void)videoView:(UIView*)videoView didChangeVideoSize:(CGSize)size;

/*! Called when the UI controls from a call should be updated. For example when the "mute" property changed this method will be called to allow updating the UI accordingly
 @param callController <Bit6CallController> object of the call
 */
- (void)refreshControlsViewForCallController:(Bit6CallController*)callController;

@end

