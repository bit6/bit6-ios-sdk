//
//  Bit6OutgoingMessage.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/23/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "Bit6Message.h"
#import "Bit6Address.h"
#import "Bit6Constants.h"

/*! A Bit6OutgoingMessage object represents a message that will be sent by the user. */
@interface Bit6OutgoingMessage : Bit6Message

/*! Initializes a Bit6OutgoingMessage object
 @param destination An <Bit6Address> object to where to send the message.
 @return a new Bit6OutgoingMessage object.
 */
- (nonnull instancetype)initWithDestination:(nonnull Bit6Address*)destination;

/*! Text content of the message. */
@property (nullable, nonatomic, copy) NSString *content;

/*! The <Bit6Address> object to reference the message's destination. */
@property (nonnull, nonatomic, strong) Bit6Address *destination;

/*! Image to send as an attachment. */
@property (nullable, nonatomic, strong) UIImage *image;

/*! URL path to the video to be sent as an attachment.
 @note It supports the following URL paths: file:// and assets-library://
 */
@property (nullable, nonatomic, strong) NSURL *videoURL;

/*! Specifies the beginning of the time range, in seconds, to be sent from the video. */
@property (nullable, nonatomic, strong) NSNumber *videoCropStart;

/*! Specifies the end of the time range, in seconds, to be sent from the video. */
@property (nullable, nonatomic, strong) NSNumber *videoCropEnd;

/*! Location to send with the message. */
@property (nonatomic) CLLocationCoordinate2D location;

/*! Returns an unique path to store an audio file. */
- (nonnull NSString*)uniqueAudioFilePath;

/*! Path of the attached audio file, if available. */
@property (nullable, nonatomic, strong) NSString *audioFilePath;

/*! Returns YES if the message attachment has been successfuly saved to cache. */
@property (nonatomic, readonly) BOOL attachmentsSavedInCache;

/*! Sends the message.
 @param completion block to be called when the operation is completed.
 */
- (void)sendWithCompletionHandler:(nullable Bit6CompletionHandler)completion;

/*! Creates a copy of a sent message. This copy has a different identifier and it's ready to be forwarded.
 @param msg message to be copied
 @return copy of the message
 */
+ (nonnull Bit6OutgoingMessage*)outgoingCopyOfMessage:(nonnull Bit6Message*)msg;

@end
