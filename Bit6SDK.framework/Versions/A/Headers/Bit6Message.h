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

@class Bit6Conversation;

/*! Channel of a <Bit6Message> call. */
typedef NS_ENUM(NSInteger, Bit6MessageCallChannel) {
    /*! The message refers to an audio call. */
    Bit6MessageCallChannel_Audio = 4,
    /*! The message refers to a data transfer call. */
    Bit6MessageCallChannel_Data,
    /*! The message refers to a video call. */
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

/*! Message attachment category for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageAttachmentCategory) {
    /*! The thumbnail image for the message. */
    Bit6MessageAttachmentCategory_THUMBNAIL = 1,
    /*! The full size attachment for the message. */
    Bit6MessageAttachmentCategory_FULL_SIZE
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

/*! The conversation the sender belongs to. */
@property (nonatomic, readonly) Bit6Conversation *conversation;

/*! The text content of the sender. */
@property (nonatomic, readonly, copy) NSString *content;

/*! The creation timestamp of the sender. */
@property (nonatomic, copy, readonly) NSNumber *created;

/*! The last updated timestamp of the sender. */
@property (nonatomic, copy, readonly) NSNumber *updated;

/*! YES if this is an incoming message. */
@property (nonatomic, readonly) BOOL incoming;

/*! Sender status as a value of the <Bit6MessageStatus> enumeration. */
@property (nonatomic, readonly) Bit6MessageStatus status;

/*! Call status as a value of the <Bit6MessageCallStatus> enumeration. This property should be used only if self.type == Bit6MessageType_Call.*/
@property (nonatomic, readonly) Bit6MessageCallStatus callStatus;

/*! Call channel as a value of the <Bit6MessageCallChannel> enumeration. This property should be used only if self.type == Bit6MessageType_Call.*/
@property (nonatomic, readonly) Bit6MessageCallChannel callChannel;

/*! Sender type as a value of the <Bit6MessageType> enumeration. */
@property (nonatomic, readonly) Bit6MessageType type;

/*! Gets the other person address as a <Bit6Address> object. */
@property (nonatomic, readonly, copy) Bit6Address *other;

/*! Gets the information about the sender attachments. */
@property (nonatomic, readonly, strong) Bit6MessageData *data;

/*! Gets the attachment type of the sender as a value of the <Bit6MessageFileType> enumeration. */
@property (nonatomic, readonly) Bit6MessageFileType attachFileType;

/*! Gets the length of the audio file attached to the sender.
 @note You should check if the sender has an audio file attached by using the Bit6Message.attachFileType property. */
@property (nonatomic, readonly) double audioDuration;

/*! Returns the status for the sender's attachments
 @param attachmentCategory attachment to query as a value of the <Bit6MessageAttachmentCategory> enumeration
 @return the attachment's status as a value of the <Bit6MessageAttachmentStatus> enumeration
 */
- (Bit6MessageAttachmentStatus) attachmentStatusForAttachmentCategory:(Bit6MessageAttachmentCategory)attachmentCategory;

/*! Returns the path for the sender's attachments
 @param attachmentCategory attachment to query as a value of the <Bit6MessageAttachmentCategory> enumeration
 @return the attachment's path
 */
- (NSString*) attachmentPathForAttachmentCategory:(Bit6MessageAttachmentCategory)attachmentCategory;

/*! Starts to download the attachment associated with the sender. If the attachment is already downloading this method does nothing.
 @param attachmentCategory attachment to download.
 @note Listen to the Bit6FileDownloadedNotification to handle downloading events.
 */
- (void) downloadAttachment:(Bit6MessageAttachmentCategory)attachmentCategory;

@end

/*! A Bit6MessageData object represents the data attached attached to a <Bit6Message> object. */
@interface Bit6MessageData : NSObject

/*! Latitude of the location included in the message. */
@property (nonatomic, copy) NSNumber *lat;

/*! Longitude of the location included in the message. */
@property (nonatomic, copy) NSNumber *lng;

/*! Gets the length of the call. This property should be used only if message == Bit6MessageType_Call. */
@property (nonatomic, copy) NSNumber *callDuration;

@end