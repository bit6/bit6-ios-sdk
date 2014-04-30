//
//  Bit6Message.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/21/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Constants.h"
#import "Bit6Address.h"

/*! Channels available for sending a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageChannel) {
    /*! The message is an SMS. */
    Bit6MessageChannel_SMS = 2,
    /*! The message is an app-to-app message. */
    Bit6MessageChannel_PUSH = 3
};

/*! Delivery status for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageStatus){
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

/*! Message type for a <Bit6Message>. */
typedef NS_ENUM(NSInteger, Bit6MessageType) {
    /*! The message has only text. */
    Bit6MessageType_Text = 1,
    /*! The message has an attachment. */
    Bit6MessageType_Attachments = 5,
    /*! The message has a location. */
    Bit6MessageType_Location = 6
};

/*! Attachment type for a <Bit6Message> */
typedef NS_ENUM(NSInteger, Bit6MessageFileType) {
    /*! The message has no attachment. */
    Bit6MessageFileType_None = 0,
    /*! The message has an MP4 audio attachment. */
    Bit6MessageFileType_AudioMP4,
    /*! The message has an PNG image attachment. */
    Bit6MessageFileType_ImagePNG,
    /*! The message has an JPEG image attachment. */
    Bit6MessageFileType_ImageJPG,
};

@class Bit6MessageData;

/*! A Bit6Message object representing a message sent or received by the user. */
@interface Bit6Message : NSObject

/*! The text content of the message. */
@property (nonatomic, copy, readonly) NSString *content;

/*! YES if this is an incoming message. */
@property (nonatomic, readonly) BOOL incoming;

/*! Message status as a value of the <Bit6MessageStatus> enumeration. */
@property (nonatomic, readonly) Bit6MessageStatus status;

/*! Message type as a value of the <Bit6MessageType> enumeration. */
@property (nonatomic, readonly) Bit6MessageType type;

/*! Gets the attachment type of this message as a value of the <Bit6MessageFileType> enumeration.
 * @return the attachment type.
 */
- (Bit6MessageFileType) attachFileType;

/*! Convenience method to open the location included in a Bit6Message object in the Apple Maps app.
 @discussion A Bit6Message object has a location included if <type> == Bit6MessageType_Location. */
- (void) openLocationOnMaps;

@end


