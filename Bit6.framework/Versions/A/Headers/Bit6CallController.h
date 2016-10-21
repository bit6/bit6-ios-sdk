//
//  Bit6CallController.h
//  Bit6
//
//  Created by Carlos Thurber on 12/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Bit6Address.h"
#import "Bit6Transfer.h"

@class Bit6CallViewController;
@protocol Bit6CallControllerDelegate;

/*! Hangup causes for a call. List available at https://wiki.freeswitch.org/wiki/Hangup_Causes  */
typedef NS_OPTIONS(NSInteger, FreeSWITCHHangupCause) {
    FreeSWITCHHangupCause_UNSPECIFIED = 0,
    FreeSWITCHHangupCause_UNALLOCATED_NUMBER = 1,
    FreeSWITCHHangupCause_NO_ROUTE_TRANSIT_NET = 2,
    FreeSWITCHHangupCause_NO_ROUTE_DESTINATION = 3,
    FreeSWITCHHangupCause_CHANNEL_UNACCEPTABLE = 6,
    FreeSWITCHHangupCause_CALL_AWARDED_DELIVERED = 7,
    FreeSWITCHHangupCause_NORMAL_CLEARING = 16,
    FreeSWITCHHangupCause_USER_BUSY = 17,
    FreeSWITCHHangupCause_NO_USER_RESPONSE = 18,
    FreeSWITCHHangupCause_NO_ANSWER = 19,
    FreeSWITCHHangupCause_SUBSCRIBER_ABSENT = 20,
    FreeSWITCHHangupCause_CALL_REJECTED = 21,
    FreeSWITCHHangupCause_NUMBER_CHANGED = 22,
    FreeSWITCHHangupCause_REDIRECTION_TO_NEW_DESTINATION = 23,
    FreeSWITCHHangupCause_EXCHANGE_ROUTING_ERROR = 25,
    FreeSWITCHHangupCause_DESTINATION_OUT_OF_ORDER = 27,
    FreeSWITCHHangupCause_INVALID_NUMBER_FORMAT = 28,
    FreeSWITCHHangupCause_FACILITY_REJECTED = 29,
    FreeSWITCHHangupCause_RESPONSE_TO_STATUS_ENQUIRY = 30,
    FreeSWITCHHangupCause_NORMAL_UNSPECIFIED = 31,
    FreeSWITCHHangupCause_NORMAL_CIRCUIT_CONGESTION = 34,
    FreeSWITCHHangupCause_NETWORK_OUT_OF_ORDER = 38,
    FreeSWITCHHangupCause_NORMAL_TEMPORARY_FAILURE = 41,
    FreeSWITCHHangupCause_SWITCH_CONGESTION = 42,
    FreeSWITCHHangupCause_ACCESS_INFO_DISCARDED = 43,
    FreeSWITCHHangupCause_REQUESTED_CHAN_UNAVAIL = 44,
    FreeSWITCHHangupCause_PRE_EMPTED = 45,
    FreeSWITCHHangupCause_RESOURCE_UNAVAILABLE = 47,
    FreeSWITCHHangupCause_FACILITY_NOT_SUBSCRIBED = 50,
    FreeSWITCHHangupCause_OUTGOING_CALL_BARRED = 52,
    FreeSWITCHHangupCause_INCOMING_CALL_BARRED = 54,
    FreeSWITCHHangupCause_BEARERCAPABILITY_NOTAUTH = 57,
    FreeSWITCHHangupCause_BEARERCAPABILITY_NOTAVAIL = 58,
    FreeSWITCHHangupCause_SERVICE_UNAVAILABLE = 63,
    FreeSWITCHHangupCause_BEARERCAPABILITY_NOTIMPL = 65,
    FreeSWITCHHangupCause_CHAN_NOT_IMPLEMENTED = 66,
    FreeSWITCHHangupCause_FACILITY_NOT_IMPLEMENTED = 69,
    FreeSWITCHHangupCause_SERVICE_NOT_IMPLEMENTED = 79,
    FreeSWITCHHangupCause_INVALID_CALL_REFERENCE = 81,
    FreeSWITCHHangupCause_INCOMPATIBLE_DESTINATION = 88,
    FreeSWITCHHangupCause_INVALID_MSG_UNSPECIFIED = 95,
    FreeSWITCHHangupCause_MANDATORY_IE_MISSING = 96,
    FreeSWITCHHangupCause_MESSAGE_TYPE_NONEXIST = 97,
    FreeSWITCHHangupCause_WRONG_MESSAGE = 98,
    FreeSWITCHHangupCause_IE_NONEXIST = 99,
    FreeSWITCHHangupCause_INVALID_IE_CONTENTS = 100,
    FreeSWITCHHangupCause_WRONG_CALL_STATE = 101,
    FreeSWITCHHangupCause_RECOVERY_ON_TIMER_EXPIRE = 102,
    FreeSWITCHHangupCause_MANDATORY_IE_LENGTH_ERROR = 103,
    FreeSWITCHHangupCause_PROTOCOL_ERROR = 111,
    FreeSWITCHHangupCause_INTERWORKING = 127,
    FreeSWITCHHangupCause_ORIGINATOR_CANCEL = 487,
    FreeSWITCHHangupCause_CRASH = 500,
    FreeSWITCHHangupCause_SYSTEM_SHUTDOWN = 501,
    FreeSWITCHHangupCause_LOSE_RACE = 502,
    FreeSWITCHHangupCause_MANAGER_REQUEST = 503,
    FreeSWITCHHangupCause_BLIND_TRANSFER = 600,
    FreeSWITCHHangupCause_ATTENDED_TRANSFER = 601,
    FreeSWITCHHangupCause_ALLOTTED_TIMEOUT = 602,
    FreeSWITCHHangupCause_USER_CHALLENGE = 603,
    FreeSWITCHHangupCause_MEDIA_TIMEOUT = 604,
    FreeSWITCHHangupCause_PICKED_OFF = 605,
    FreeSWITCHHangupCause_USER_NOT_REGISTERED = 606,
    FreeSWITCHHangupCause_PROGRESS_TIMEOUT = 607,
    FreeSWITCHHangupCause_GATEWAY_DOWN = 609
};

/*! Call streams. */
typedef NS_OPTIONS(NSInteger, Bit6CallStreams) {
    /*! No stream. */
    Bit6CallStreams_None = 0,
    /*! Audio stream. */
    Bit6CallStreams_Audio = 1 << 0,
    /*! Video stream. */
    Bit6CallStreams_Video = 1 << 1,
    /*! Data stream. */
    Bit6CallStreams_Data = 1 << 2
};

/*! States for the Data Channel stream. */
typedef NS_OPTIONS(NSInteger, Bit6DataChannelState) {
    /*! The data channel is connecting. */
    Bit6DataChannelState_Connecting,
    /*! The data channel is open. */
    Bit6DataChannelState_Open,
    /*! The data channel is closing. */
    Bit6DataChannelState_Closing,
    /*! The data channel is closed. */
    Bit6DataChannelState_Closed
};

/*! Video sources to sent in a call. */
typedef NS_OPTIONS(NSInteger, Bit6VideoSource) {
    /*! No video source to use. */
    Bit6VideoSource_None,
    /*! Video source for the rear camera. */
    Bit6VideoSource_CameraBack,
    /*! Video source for the front camera. */
    Bit6VideoSource_CameraFront
};

/*! Call status. */
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
    Bit6CallState_END
};

/*! Call Capabilities. */
typedef NS_ENUM(NSInteger, Bit6CallCapability) {
    /*! The call can be recorded. */
    Bit6CallCapability_Recording
};

NS_ASSUME_NONNULL_BEGIN

typedef NSString* Bit6CallMediaMode NS_STRING_ENUM;

/*! The call will go P2P. */
extern Bit6CallMediaMode const Bit6CallMediaModeP2P;

/*! The call media will be processed by Bit6 servers. */
extern Bit6CallMediaMode const Bit6CallMediaModeMix;

/*! Bit6CallController represents a call. */
@interface Bit6CallController : NSObject

///---------------------------------------------------------------------------------------
/// @name ￼Call Properties
///---------------------------------------------------------------------------------------

/*! Unique identifier for the call */
@property (nonatomic, strong) NSUUID *uuid;

/*! Adds a delegate to be notified of changes in the call. 
 @param delegate object to notify of changes in the call.
 */
- (void)addDelegate:(id<Bit6CallControllerDelegate>)delegate;

/*! Removes a call delegate.
 @param delegate object to remove from the call delegates.
 */
- (void)removeDelegate:(id<Bit6CallControllerDelegate>)delegate;

/*! Call state as a value of the <Bit6MessageStatus> enumeration.
 @discussion For incoming calls the states go: <b>NEW</b> -> <b>ACCEPTING_CALL</b> -> <b>WAITING_SDP</b> -> <b>GATHERING_CANDIDATES</b> -> <b>SENDING_SDP</b> -> <b>CONNECTING</b> -> <b>CONNECTED</b> -> <b>END</b><br />
 For outgoing calls the states go: <b>NEW</b> -> <b>GATHERING_CANDIDATES</b> -> <b>SENDING_SDP</b> -> <b>WAITING_SDP</b> -> <b>CONNECTING</b> -> <b>CONNECTED</b> -> <b>END</b><br />
 */
@property (nonatomic, readonly) Bit6CallState state;

/*! Unique identifier for the incoming call. */
@property (nullable, nonatomic, readonly) NSString *incomingCallIdentifier;

/*! Display name of other side of the call. */
@property (nonatomic, strong) NSString *otherDisplayName;

/*! The call is an incoming call. */
@property (nonatomic, readonly) BOOL incoming;

/*! The incoming call was answered by using the system push notification. */
@property (nonatomic, readonly) BOOL answered;

/*! The message shown in the incoming call system push notification. */
@property (nullable, nonatomic, strong, readonly) NSString *incomingAlert;

/*! The latest error to occur during the call. */
@property (nullable, nonatomic, strong, readonly) NSError *error;

/*! Identity of the other side of the call. */
@property (nonatomic, strong, readonly) Bit6Address *other;

/*! An integer bit mask that indicates the local streams being sent during the call. */
@property (nonatomic) Bit6CallStreams localStreams;

/*! An integer bit mask that indicates the remote streams being received during the call. */
@property (nonatomic) Bit6CallStreams remoteStreams;

/*! An integer bit mask that indicates the possible streams in the incoming call. */
@property (nonatomic) Bit6CallStreams availableStreamsForIncomingCall;

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
@property (nonatomic, readonly) FreeSWITCHHangupCause endedCauseCode;

/*! Cause message for the call ended, if available. */
@property (nullable, nonatomic, strong, readonly) NSString* endedCause;

/*! Used to know if the call didn't connect because it was rejected. */
@property (nonatomic, readonly) BOOL rejected;

/*! Used to know if the call ended without being answered. */
@property (nonatomic, readonly) BOOL missed;

/*! Indicates if the call will go P2P or if the server should process the media. P2P Can't be used for group calls, or if offnet property is set to true. */
@property (nonatomic, strong) Bit6CallMediaMode mediaMode;

/*! Indicates if the call will go within the Bit6 world (set to false) or it should be a real phone call (set to true). */
@property (nonatomic) BOOL offnet;

///---------------------------------------------------------------------------------------
/// @name ￼CallKit
///---------------------------------------------------------------------------------------

@property (nonatomic, readonly) BOOL callKitSupported;

///---------------------------------------------------------------------------------------
/// @name ￼Capabilities
///---------------------------------------------------------------------------------------

/*! Indicates if the calls supports the specified capability.
 @param capability capability to find out if the call supports.
 @return YES if the call supports the specified capability.
 */
- (BOOL)supportsCapability:(Bit6CallCapability)capability;

/*! Starts and stop recording during a call. This can only be used if call media mode is set to Bit6CallMediaModeMix.
 @see -[Bit6CallController supportsCapability:] */
@property (nonatomic) BOOL recording;

///---------------------------------------------------------------------------------------
/// @name ￼Actions
///---------------------------------------------------------------------------------------

/*! Starts the call */
- (void)start;

/*! Play the ringtone defined in the incoming push notification payload. */
- (void)playRingtone;

/*! Send a hangup message to the sender. */
- (void)hangup;

/*! Send a hangup message to all <Bit6CallController> objects. */
+ (void)hangupAll;

@end

@interface Bit6CallController (DataChannel)

/*! Data channel state as a value of the <Bit6CallState> enumeration. */
@property (nonatomic, readonly) Bit6DataChannelState dataChannelState;

///---------------------------------------------------------------------------------------
/// @name ￼Transfers
///---------------------------------------------------------------------------------------

/*! List of outgoing <Bit6Transfer> for the current call. */
@property (nonatomic, readonly) NSArray<Bit6OutgoingTransfer*>* outgoingTransfers;

/*! List of incoming <Bit6Transfer> for the current call. */
@property (nonatomic, readonly) NSArray<Bit6Transfer*>* incomingTransfers;

/*! Starts the specified <Bit6OutgoingTransfer> through this call. If there's another transfer going on, this new transfer will be added to a queue.
 @param transfer <Bit6OutgoingTransfer> to start.
 */
- (void)addTransfer:(Bit6OutgoingTransfer*)transfer;

@end

@interface Bit6CallController (InputOutput)

/*! The audio from the call is going through the speaker. */
+ (BOOL)isSpeakerEnabled;

/*! The audio from the call is going out through a bluetooth device. */
+ (BOOL)isBluetoothEnabled;

/*! The audio is muted for the current call. */
+ (BOOL)isLocalAudioEnabled;

/*! The video is muted for the current call. */
+ (BOOL)isLocalVideoEnabled;

/*! The current source for the video being sent. */
+ (Bit6VideoSource)localVideoSource;

/*! Switch between the frontal and rear camera, and other video sources if available. This will be applied to all the running callControllers.
 @param source the video source to sent during the calls.
 */
+ (void)setLocalVideoSource:(Bit6VideoSource)source;

/*! Mute and unmute the microphone in the current call. This will be applied to all the running callControllers.
 @param flag NO to mute the microphone.
 */
+ (void)setLocalAudioEnabled:(BOOL)flag;

/*! Mute and unmute the video in the current call. This will be applied to all the running callControllers.
 @param flag NO to mute the local video.
 */
+ (void)setLocalVideoEnabled:(BOOL)flag;

/*! Change the audio route from the default one to the speaker, and vice versa. This will be applied to all the running callControllers.
 @param flag YES to enable speaker.
 */
+ (BOOL)setSpeakerEnabled:(BOOL)flag;

/*! Change the audio route from the default one to the available bluetooth device, and vice versa. This will be applied to all the running callControllers.
 @param flag YES to enable bluetooth.
 */
+ (BOOL)setBluetoothEnabled:(BOOL)flag;

@end

/*! The Bit6DataChannelDelegate protocol defines the methods an object should implement to listen to changes during a call.
 */
@protocol Bit6CallControllerDelegate <NSObject>

@optional

/*! Called when the data channel state has changed. This method is called in the main thread.
 @param callController The call for which the data channel has changed status.
 @param state new state for the data channel.
 */
- (void)callController:(Bit6CallController*)callController dataChannelDidChangeToState:(Bit6DataChannelState)state;

/*! Called when the call state has changed. This method is called in the main thread.
 @param callController The call for which the state has changed.
 @param state new state for the call.
 */
- (void)callController:(Bit6CallController*)callController callDidChangeToState:(Bit6CallState)state;

/*! Called each second to allow the refresh of a timer UI. This method is called in the main thread.
 @param callController <BitCallController> object which 'seconds' property has changed.
 */
- (void)secondsDidChangeForCallController:(Bit6CallController*)callController;

/*! Called to notify changes in a transfer during a call. This method is called in the main thread.
 @param callController <BitCallController> object referring to the call.
 @param transfer transfer to which the update refers to.
 @param change change occurring to the transfer. Can be one of the following constants: Bit6TransferStartedKey, Bit6TransferProgressKey, Bit6TransferEndedKey, Bit6TransferEndedWithErrorKey.
 */
- (void)callController:(Bit6CallController*)callController transfer:(Bit6Transfer*)transfer change:(NSString*)change;

/*! Called when the local video feed will be interrupted. This method is called in the main thread.
 @param callController <BitCallController> object referring to the call.
 @param reason reason for the interruption as a AVCaptureSessionInterruptionReason value. Only AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps is supported at the moment.
 */
- (void)callController:(Bit6CallController*)callController localVideoFeedInterruptedBecause:(int)reason;

/*! Called when the local video feed interruption has ended. This method is called in the main thread.
 @param callController <BitCallController> object referring to the call.
 */
- (void)localVideoFeedInterruptionEndedForCallController:(Bit6CallController*)callController;

@end

NS_ASSUME_NONNULL_END

