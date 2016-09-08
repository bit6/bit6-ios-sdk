//
//  Bit6Constants.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^Bit6CompletionHandler) (NSDictionary<id,id>* _Nullable response, NSError* _Nullable error);
typedef void (^Bit6ActionNotificationCompletionHandler) (void);

extern NSString* const Bit6LoginCompletedNotification;
extern NSString* const Bit6LogoutCompletedNotification;

extern NSString* const Bit6RTConnectionStatusChangedNotification;
extern NSString* const Bit6CustomRtNotification;
extern NSString* const Bit6PresenceRtNotification;

extern NSString* const Bit6IncomingCallNotification;
extern NSString* const Bit6CallAddedNotification;
extern NSString* const Bit6CallMissedNotification;
extern NSString* const Bit6CallPermissionsMissingNotification;

extern NSString* const Bit6IncomingMessageNotification;
extern NSString* const Bit6MessageKey;
extern NSString* const Bit6AddressKey;
extern NSString* const Bit6FromKey;
extern NSString* const Bit6ToKey;
extern NSString* const Bit6TappedKey;

extern NSString* const Bit6AudioPlayingNotification;

extern NSString* const Bit6CacheDeletedNotification;

extern NSString* const Bit6ActiveIdentityChangedNotification;

extern NSString* const Bit6MessagesChangedNotification;
extern NSString* const Bit6ConversationsChangedNotification;
extern NSString* const Bit6GroupsChangedNotification;
extern NSString* const Bit6ObjectKey;
extern NSString* const Bit6ChangeKey;
extern NSString* const Bit6AddedKey;
extern NSString* const Bit6UpdatedKey;
extern NSString* const Bit6DeletedKey;
extern NSString* const Bit6ErrorKey;

extern NSString* const Bit6TypingDidBeginRtNotification;
extern NSString* const Bit6TypingDidEndRtNotification;

extern NSString* const Bit6ProgressKey;
extern NSString* const Bit6TransferStartedKey;
extern NSString* const Bit6TransferProgressKey;
extern NSString* const Bit6TransferEndedKey;
extern NSString* const Bit6TransferEndedWithErrorKey;

/*! Bit6 error constants */
typedef NS_ENUM(NSInteger, Bit6Error) {
    /*! The recipient was not found. */
    Bit6Error_RecipientNotFound=500,
    /*! Can't delete a message with status Sending. */
    Bit6Error_UnableToDeleteSendingMessage=-631,
    /*! Couldn't make changes to the group. */
    Bit6Error_UnableToUpdateGroup=-632,
    /*! The group wasn't found in the server. Probably because of not enough permissions to see it. */
    Bit6Error_GroupNotAccessible=-633,
    
    /*! Internet connection not found. */
    Bit6Error_NotConnectedToInternet = NSURLErrorNotConnectedToInternet,
    
    /*! Restricted access to the Microphone. */
    Bit6Error_MicNotAllowed=-6001,
    /*! Restricted access to the Camera. */
    Bit6Error_CameraNotAllowed=-6002,
    /*! Restricted access to Location. */
    Bit6Error_LocationNotAllowed=-6003,
    /*! Session hasn't being initiated. */
    Bit6Error_SessionNotInitiated=-6011,
    /*! Invalid Address. */
    Bit6Error_InvalidAddress=-6012,
    /*! Insuficient Parameters. */
    Bit6Error_InsuficientParameters=-6013,
    /*! Invalid Session Provider. */
    Bit6Error_InvalidSessionProvider=-6014,
    /*! Attachment wasn't saved to cache. */
    Bit6Error_SaveToCacheFailed=-6021,
    /*! Attachment doesn't exist in cache. */
    Bit6Error_FileDoesNotExists=-6022,
    /*! Attachment doesn't exist in cache, but it is being downloaded. */
    Bit6Error_FileDoesNotExistsWillDownload=-6023,
    /*! Attachment doesn't exist in the server, probably because an error during the upload process. */
    Bit6Error_FileDoesNotExistsOnServer=-6024,
    /*! An HTTP status = 5xx occur when interacting with the server. */
    Bit6Error_HTTPServerError=-6031,
    /*! An HTTP status = 4xx occur when interacting with the server. */
    Bit6Error_HTTPClientError=-6032,
    /*! An HTTP status = 4xx occur when interacting with the server. */
    Bit6Error_InvalidRESTAPICall=-6051,
    
    /*! Failed to Start the call. */
    Bit6Error_CallFailedToStartError=-10001,
    /*! Call connection failed. */
    Bit6Error_CallConnectionFailedError=-10002,
    
    /*! The <Bit6Transfer> failed because the data channel wasn't open. */
    Bit6Error_TransferDataChannelNotOpenError=-10011,
    /*! The <Bit6Transfer> failed because of an unknown error. */
    Bit6Error_TransferDataChannelUnknownError=-10012,
    /*! The <Bit6Transfer> failed because of an buffer overflow error. */
    Bit6Error_TransferDataChannelBufferOverflowError=-10013
};

/*! Web Socket connection status. */
typedef NS_ENUM(NSInteger, Bit6WebSocketReadyState) {
    /*! Web Socket is disconnected. */
    Bit6WebSocketReadyState_DISCONNECTED = 0,
    /*! Web Socket is tring to connect. */
    Bit6WebSocketReadyState_CONNECTING,
    /*! Web Socket is connected. */
    Bit6WebSocketReadyState_CONNECTED
};

typedef NS_OPTIONS(NSInteger, Bit6LogOptions) {
    Bit6LogOptions_None = 0,
    Bit6LogOptions_Default = 1 << 0,
    Bit6LogOptions_Models = 1 << 1,
    Bit6LogOptions_ApiCalls = 1 << 2,
    Bit6LogOptions_VoIP = 1 << 3,
    Bit6LogOptions_CallKit = 1 << 4,
    Bit6LogOptions_RTNotifications = 1 << 5,
    Bit6LogOptions_FileManager = 1 << 6,
    Bit6LogOptions_SQLite = 1 << 7,
    Bit6LogOptions_Debug = 1 << 8,
};

NS_ASSUME_NONNULL_END
