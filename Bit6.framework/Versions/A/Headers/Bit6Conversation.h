//
//  Bit6Conversation.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Address.h"
#import "Bit6Message.h"

@class Bit6Group;

NS_ASSUME_NONNULL_BEGIN

/*! Bit6Conversation represents a conversation (or a chat) - a set of messages between two participants. */
@interface Bit6Conversation : NSObject

/*! Unavailable init
 @return a new instance of the class.
 */
- (instancetype)init NS_UNAVAILABLE;

/*! Returns a Bit6Conversation object based on the <Bit6Address> indicated. If the conversation didn't exists a new one will be created.
 @param address <Bit6Address> object for the conversation.
 @return a Bit6Conversation object for the <Bit6Address> indicated.
 */
+ (Bit6Conversation*)conversationWithAddress:(Bit6Address*)address;

/*! The <Bit6Message> objects in the sender as a NSArray. */
@property (nonatomic, copy, readonly) NSArray<Bit6Message*>* messages;

/*! The <Bit6Address> object associated with the sender. */
@property (nonatomic, readonly) Bit6Address* address;

/*! The <Bit6Group> object associated with the sender. */
@property (nullable, nonatomic, readonly) Bit6Group* group;

/*! Gets the number of unread messages for the sender.
 */
@property (nonatomic, readonly) NSNumber* badge;

/*! Last message received or sent in the conversation. */
@property (nullable, nonatomic, strong, readonly) Bit6Message* lastMessage;

/*! Gets the current typing user as a <Bit6Address> object, if available. */
@property (nullable, nonatomic, strong) Bit6Address* typingAddress;

/*! Returns an NSComparisonResult value that indicates whether the conversation timestamp value is greater than, equal to, or less than a given conversation timestamp. 
 @param conversation The conversation to compare to the conversation timestamp's value. This value must not be nil.
 */
- (NSComparisonResult)compare:(Bit6Conversation*)conversation;

/*! Returns the timestamp matching the last message in this conversation with status Bit6MessageStatus_Delivered. */
@property (nonatomic, readonly) double deliveredUntil;

/*! Returns the timestamp matching the last message in this conversation with status Bit6MessageStatus_Read. */
@property (nonatomic, readonly) double readUntil;

@end

NS_ASSUME_NONNULL_END
