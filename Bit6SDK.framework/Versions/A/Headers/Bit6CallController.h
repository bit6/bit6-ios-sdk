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
#import "Bit6Transfer.h"

@class Bit6CallViewController;

/*! Call status for a <Bit6CallController>. */
typedef NS_ENUM(NSInteger, Bit6CallState) {
    /*! The call hasn't started. */
    Bit6CallState_NEW,
    /*! The call is starting. */
    Bit6CallState_PROGRESS,
    /*! The call has started. */
    Bit6CallState_ANSWER,
    /*! The call is disconnected for the moment. */
    Bit6CallState_DISCONNECTED,
    /*! The call ended. */
    Bit6CallState_END,
    /*! The call ended with an error. */
    Bit6CallState_ERROR,
    /*! It is a missed call. */
    Bit6CallState_MISSED,
};

/*! Bit6CallController represents an in-progress call. */
@interface Bit6CallController : NSObject

/*! Starts a call
 @param viewController a <Bit6CallViewController> object in which to start the call. 
 */
- (void) connectToViewController:(Bit6CallViewController*)viewController;

///---------------------------------------------------------------------------------------
/// @name ￼Call Properties
///---------------------------------------------------------------------------------------

/*! Call status as a value of the <Bit6MessageStatus> enumeration. */
@property (nonatomic, readonly) Bit6CallState callState;

/*! Display name of other side of the call. */
@property (nonatomic, strong) NSString *otherDisplayName;

/*! The incoming call was answered by using the system push notification. */
@property (nonatomic, readonly) BOOL incomingCallAnswered;

/*! The message shown in the incoming call system push notification. */
@property (nonatomic, strong) NSString *incomingCallAlert;

/*! The latest error to occur during the call. */
@property (nonatomic, strong, readonly) NSError *error;

/*! Identity of the other side of the call. */
@property (nonatomic, strong, readonly) Bit6Address *other;

/*! The current call supports video. */
@property (nonatomic, readonly) BOOL hasVideo;

/*! The current call supports audio. */
@property (nonatomic, readonly) BOOL hasAudio;

/*! The current call supports data transfer. */
@property (nonatomic, readonly) BOOL hasData;

/*! The number of seconds the call has been going */
@property (nonatomic, readonly) NSUInteger seconds;

/*! The audio from the call is going through the speaker */
+ (BOOL) speakerEnabled;

/*! The audio is muted for the current call */
+ (BOOL) audioMuted;

/*! The video is muted for the current call */
+ (BOOL) videoMuted;

/*! List of outgoing <Bit6Transfer> for the current call. */
@property (nonatomic, readonly) NSArray *outgoingTransfers;

/*! List of incoming <Bit6Transfer> for the current call. */
@property (nonatomic, readonly) NSArray *incomingTransfers;

///---------------------------------------------------------------------------------------
/// @name ￼Actions
///---------------------------------------------------------------------------------------

/*! Switch between the frontal and rear camera, if available. This will be applied to all the running callControllers. */
+ (void) switchCamera;

/*! Mute and unmute the microphone in the current call. This will be applied to all the running callControllers. */
+ (void) switchMuteAudio;

/*! Mute and unmute the video in the current call. This will be applied to all the running callControllers. */
+ (void) switchMuteVideo;

/*! Change the audio route from the default one to the speaker, and vice versa. This will be applied to all the running callControllers. */
+ (void) switchSpeaker;

/*! Send a hangup message to the sender. */
- (void) hangup;

/*! Send a hangup message to all <Bit6CallController> objects. */
+ (void) hangupAll;

/*! Declines the call */
- (void) declineCall;

/*! Starts the specified <Bit6Transfer> through this call.
@param transfer <Bit6Transfer> to start.
 */
- (void) startTransfer:(Bit6Transfer*)transfer;

///---------------------------------------------------------------------------------------
/// @name ￼Ringtone
///---------------------------------------------------------------------------------------

/*! Play the ringtone defined in the incoming push notification payload. */
- (void) startRingtone;

@end

