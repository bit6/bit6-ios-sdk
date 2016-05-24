//
//  Bit6Message.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/21/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Address.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>

@class Bit6Conversation;

/*! Channel of a <Bit6Message> call. */
typedef NS_ENUM(NSInteger, Bit6MessageCallChannel) {
    /*! The call has an audio channel. */
    Bit6MessageCallChannel_Audio = 4,
    /*! The call has a data transfer channel. */
    Bit6MessageCallChannel_Data,
    /*! The call has a video channel. */
    Bit6MessageCallChannel_Video
};

/*! Delivery status for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageStatus){
    /*! The message is new. */
    Bit6MessageStatus_New = 0,
    /*! The message is being sent. */
    Bit6MessageStatus_Sending = 1,
    /*! The message has been sent. */
    Bit6MessageStatus_Sent,
    /*! The message sending has failed. */
    Bit6MessageStatus_Failed,
    /*! The message has been delivered. */
    Bit6MessageStatus_Delivered,
    /*! The message has been read. */
    Bit6MessageStatus_Read
};

/*! Call status for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageCallStatus){
    /*! The call has been answered. */
    Bit6MessageCallStatus_Answer = 1,
    /*! The call has been missed. */
    Bit6MessageCallStatus_Missed,
    /*! The call failed. */
    Bit6MessageCallStatus_Failed,
    /*! The call wasn't answered. */
    Bit6MessageCallStatus_NoAnswer,
};

/*! Message type for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageType) {
    /*! The message has only text. */
    Bit6MessageType_Text = 1,
    /*! The message is for a call. */
    Bit6MessageType_Call = 3,
    /*! The message has an attachment. */
    Bit6MessageType_Attachments = 5,
    /*! The message has a location. */
    Bit6MessageType_Location = 6
};

/*! Attachment type for a <Bit6Message> */
typedef NS_ENUM(NSInteger, Bit6MessageFileType) {
    /*! The message has no attachment. */
    Bit6MessageFileType_None = 0,
    /*! The message has an audio attachment. */
    Bit6MessageFileType_Audio,
    /*! The message has an image attachment. */
    Bit6MessageFileType_Image,
    /*! The message has a video attachment. */
    Bit6MessageFileType_Video = 4,
};

/*! Message attachment status for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageAttachmentStatus) {
    /*! The message doesn't have the specified attachment */
    Bit6MessageAttachmentStatus_INVALID = -2,
    /*! The attachment doesn't exists */
    Bit6MessageAttachmentStatus_FAILED,
    /*! The attachment is not in cache */
    Bit6MessageAttachmentStatus_NOT_FOUND,
    /*! The attachment is being downloaded */
    Bit6MessageAttachmentStatus_DOWNLOADING,
    /*! The attachment is in cache */
    Bit6MessageAttachmentStatus_FOUND
};

@class Bit6MessageData;

/*! A Bit6Message object represents a message sent or received by the user. */
@interface Bit6Message : NSObject

/*! Unavailable init
 @return a new instance of the class.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/*! The conversation the sender belongs to. */
@property (nullable, nonatomic, readonly) Bit6Conversation *conversation;

/*! The text content of the sender. */
@property (nullable, nonatomic, readonly, copy) NSString *content;

/*! The creation timestamp of the sender. */
@property (nonnull, nonatomic, copy, readonly) NSNumber *created;

/*! The last updated timestamp of the sender. */
@property (nullable, nonatomic, copy, readonly) NSNumber *updated;

/*! YES if this is an incoming message. */
@property (nonatomic, readonly) BOOL incoming;

/*! Sender status as a value of the <Bit6MessageStatus> enumeration. */
@property (nonatomic, readonly) Bit6MessageStatus status;

/*! Call status as a value of the <Bit6MessageCallStatus> enumeration. This property should be used only if self.type == Bit6MessageType_Call.*/
@property (nonatomic, readonly) Bit6MessageCallStatus callStatus;

/*! Sender type as a value of the <Bit6MessageType> enumeration. */
@property (nonatomic, readonly) Bit6MessageType type;

/*! Gets the other person address as a <Bit6Address> object. */
@property (nullable, nonatomic, readonly, copy) Bit6Address *other;

/*! Gets the attachment type of the sender as a value of the <Bit6MessageFileType> enumeration. */
@property (nonatomic, readonly) Bit6MessageFileType attachFileType;

/*! Gets the length of the audio file attached to the sender.
 @note You should check if the sender has an audio file attached by using the Bit6Message.attachFileType property. */
@property (nonatomic, readonly) double audioDuration;

/*! Determine if the call had the specific channel. This method should be used only if self.type == Bit6MessageType_Call.
 @param channel Channel to look for in the call.
 @return true if the call had the specific channel.
 */
- (BOOL) callHasChannel:(Bit6MessageCallChannel)channel;

/*! The status for the sender's thumbnail attachment as a value of the <Bit6MessageAttachmentStatus> enumeration. */
@property (nonatomic, readonly) Bit6MessageAttachmentStatus statusForThumbnailAttachment;

/*! The status for the sender's full attachment as a value of the <Bit6MessageAttachmentStatus> enumeration. */
@property (nonatomic, readonly) Bit6MessageAttachmentStatus statusForFullAttachment;

/*! The path for the sender's full attachment. */
@property (nullable, nonatomic, readonly) NSString *pathForThumbnailAttachment;

/*! The path for the sender's full attachment. */
@property (nullable, nonatomic, readonly) NSString *pathForFullAttachment;

/*! The remote url for the sender's thumbnail attachment. */
@property (nullable, nonatomic, readonly) NSURL *remoteURLForThumbnailAttachment;

/*! The remote url for the sender's full attachment. */
@property (nullable, nonatomic, readonly) NSURL *remoteURLForFullAttachment;

/*! The remote url for the sender's full attachment. */
@property (nullable, nonatomic, readonly) NSString *attachmentType;

/*! Location attached to the message if available, or kCLLocationCoordinate2DInvalid if not. */
@property (nonatomic, readonly) CLLocationCoordinate2D location;

/*! Gets the length of the call. This property should be used only if self.type == Bit6MessageType_Call. */
@property (nullable, nonatomic, readonly) NSNumber *callDuration;

@end
