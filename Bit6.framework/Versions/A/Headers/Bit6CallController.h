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

/*! Call stream for a <Bit6CallController>. */
typedef NS_OPTIONS(NSInteger, Bit6CallStreams) {
    /*! Audio stream. */
    Bit6CallStreams_Audio = 1 << 0,
    /*! Video stream. */
    Bit6CallStreams_Video = 1 << 1,
    /*! Data stream. */
    Bit6CallStreams_Data = 1 << 2
};

/*! Call status for a <Bit6CallController>. */
typedef NS_ENUM(NSInteger, Bit6CallState) {
    /*! The call hasn't started. */
    Bit6CallState_NEW,
    /*! Answering the incoming call. */
    Bit6CallState_ACCEPTING_CALL,
    /*! Preparing the local sdp candidates. */
    Bit6CallState_GATHERING_CANDIDATES,
    /*! Waiting for remote sdp. */
    Bit6CallState_WAITING_SDP,
    /*! Sending local sdp. */
    Bit6CallState_SENDING_SDP,
    /*! Connecting to the call. */
    Bit6CallState_CONNECTING,
    /*! The call has started. */
    Bit6CallState_CONNECTED,
    /*! The call is disconnected for the moment. */
    Bit6CallState_DISCONNECTED,
    /*! The call ended. */
    Bit6CallState_END,
    
    /*! The call ended with an error. */
    Bit6CallState_ERROR,
    /*! It is a missed call. */
    Bit6CallState_MISSED
};

/*! Bit6CallController represents a call. */
@interface Bit6CallController : NSObject

///---------------------------------------------------------------------------------------
/// @name ￼Call Properties
///---------------------------------------------------------------------------------------

/*! Call status as a value of the <Bit6MessageStatus> enumeration.
 @discussion For incoming calls the states go: <b>NEW</b> -> <b>ACCEPTING_CALL</b> -> <b>WAITING_SDP</b> -> <b>GATHERING_CANDIDATES</b> -> <b>SENDING_SDP</b> -> <b>CONNECTING</b> -> <b>CONNECTED</b> -> <b>END</b><br />
 For outgoing calls the states go: <b>NEW</b> -> <b>GATHERING_CANDIDATES</b> -> <b>SENDING_SDP</b> -> <b>WAITING_SDP</b> -> <b>CONNECTING</b> -> <b>CONNECTED</b> -> <b>END</b><br />
 */
@property (nonatomic, readonly) Bit6CallState state;

/*! Display name of other side of the call. */
@property (nonnull, nonatomic, strong) NSString *otherDisplayName;

/*! The call is an incoming call. */
@property (nonatomic, readonly) BOOL incoming;

/*! The incoming call was answered by using the system push notification. */
@property (nonatomic, readonly) BOOL answered;

/*! The message shown in the incoming call system push notification. */
@property (nullable, nonatomic, strong, readonly) NSString *incomingAlert;

/*! The latest error to occur during the call. */
@property (nullable, nonatomic, strong, readonly) NSError *error;

/*! Identity of the other side of the call. */
@property (nonnull, nonatomic, strong, readonly) Bit6Address *other;

/*! An integer bit mask that indicates the local streams being sent during the call. */
@property (nonatomic) Bit6CallStreams localStreams;

/*! An integer bit mask that indicates the remote streams being received during the call. */
@property (nonatomic, readonly) Bit6CallStreams remoteStreams;

/*! The local streams being sent include an audio track. */
@property (nonatomic, readonly) BOOL hasAudio;

/*! The local streams being sent include a video track. */
@property (nonatomic, readonly) BOOL hasVideo;

/*! The local streams being sent include support for data transfer. */
@property (nonatomic, readonly) BOOL hasData;

/*! The remote streams being received include an audio track. */
@property (nonatomic, readonly) BOOL hasRemoteAudio;

/*! The remote streams being received include a video track. */
@property (nonatomic, readonly) BOOL hasRemoteVideo;

/*! The remote streams being received include support for data transfer. */
@property (nonatomic, readonly) BOOL hasRemoteData;

/*! The number of seconds the call has been going. */
@property (nonatomic, readonly) NSUInteger seconds;

/*! Cause code for the call ended, if available. */
@property (nonatomic, readonly) NSInteger endedCauseCode;

/*! Cause message for the call ended, if available. */
@property (nullable, nonatomic, strong, readonly) NSString* endedCause;

/*! The audio from the call is going through the speaker. */
+ (BOOL)speakerEnabled;

/*! The audio from the call is going out through a bluetooth device. */
+ (BOOL)bluetoothEnabled;

/*! The audio is muted for the current call. */
+ (BOOL)audioMuted;

/*! The video is muted for the current call. */
+ (BOOL)videoMuted;

/*! The call is streaming the video feed from the back camera. */
+ (BOOL)usingRearCamera;

///---------------------------------------------------------------------------------------
/// @name ￼Transfers
///---------------------------------------------------------------------------------------

/*! List of outgoing <Bit6Transfer> for the current call. */
@property (nonnull, nonatomic, readonly) NSArray<Bit6OutgoingTransfer*>* outgoingTransfers;

/*! List of incoming <Bit6Transfer> for the current call. */
@property (nonnull, nonatomic, readonly) NSArray<Bit6Transfer*>* incomingTransfers;

///---------------------------------------------------------------------------------------
/// @name ￼Actions
///---------------------------------------------------------------------------------------

/*! Starts the call */
- (void)start;

/*! Starts the specified <Bit6OutgoingTransfer> through this call.
 @param transfer <Bit6OutgoingTransfer> to start.
 */
- (void)startTransfer:(nonnull Bit6OutgoingTransfer*)transfer;

/*! Play the ringtone defined in the incoming push notification payload. */
- (void)playRingtone;

/*! Switch between the frontal and rear camera, if available. This will be applied to all the running callControllers. */
+ (void)switchCamera;

/*! Mute and unmute the microphone in the current call. This will be applied to all the running callControllers. */
+ (void)switchMuteAudio;

/*! Mute and unmute the video in the current call. This will be applied to all the running callControllers. */
+ (void)switchMuteVideo;

/*! Change the audio route from the default one to the speaker, and vice versa. This will be applied to all the running callControllers. */
+ (void)switchSpeaker;

/*! Change the audio route from the default one to the available bluetooth device, and vice versa. This will be applied to all the running callControllers. */
+ (void)switchBluetooth;

/*! Send a hangup message to the sender. */
- (void)hangup;

/*! Send a hangup message to all <Bit6CallController> objects. */
+ (void)hangupAll;

/*! Declines the call */
- (void)decline;

@end

