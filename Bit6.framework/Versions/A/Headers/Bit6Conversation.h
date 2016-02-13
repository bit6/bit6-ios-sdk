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

/*! Bit6Conversation represents a conversation (or a chat) - a set of messages between two participants. */
@interface Bit6Conversation : NSObject

/*! Returns a Bit6Conversation object based on the <Bit6Address> indicated. If the conversation didn't exists a new one will be created.
 @param address <Bit6Address> object for the conversation.
 @return a Bit6Conversation object for the <Bit6Address> indicated.
 */
+ (nonnull Bit6Conversation*)conversationWithAddress:(nonnull Bit6Address*)address;

/*! The <Bit6Message> objects in the sender as a NSArray. */
@property (nonnull, nonatomic, readonly) NSArray<Bit6Message*>* messages;

/*! The <Bit6Address> object associated with the sender. */
@property (nonnull, nonatomic, readonly) Bit6Address* address;

/*! The <Bit6Group> object associated with the sender. */
@property (nullable, nonatomic, readonly) Bit6Group* group;

/*! Gets the number of unread messages for the sender.
 @see [Bit6.setCurrentConversation](Bit6.html#//api/name/setCurrentConversation:)
 */
@property (nonnull, nonatomic, readonly) NSNumber* badge;

/*! Last message received or sent in the conversation. */
@property (nonnull, nonatomic, strong, readonly) Bit6Message* lastMessage;

/*! Gets the current typing user as a <Bit6Address> object, if available. */
@property (nullable, nonatomic, strong) Bit6Address* typingAddress;

/*! Returns an NSComparisonResult value that indicates whether the conversation timestamp value is greater than, equal to, or less than a given conversation timestamp. 
 @param conversation The conversation to compare to the conversation timestamp's value. This value must not be nil.
 */
- (NSComparisonResult)compare:(nonnull Bit6Conversation*)conversation;

@end
