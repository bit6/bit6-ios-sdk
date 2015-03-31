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

/*! Bit6Conversation represents a conversation (or a chat) - a set of messages between two participants.
 
 How to create a conversation object:
 
    Bit6Address *address = [Bit6Address addressWithKind:Bit6AddressKind_USERNAME value:@"user2"];
    Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
 
 */
@interface Bit6Conversation : NSObject

/*! Returns a Bit6Conversation object based on the <Bit6Address> indicated. If the conversation didn't exists a new one will be created.
 @param address <Bit6Address> object for the conversation.
 @return a Bit6Conversation object for the <Bit6Address> indicated.
 */
+ (Bit6Conversation*) conversationWithAddress:(Bit6Address*)address;

/*! The <Bit6Message> objects in the sender as a NSArray. */
@property (nonatomic, readonly) NSArray *messages;

/*! The <Bit6Address> object associated with the sender. */
@property (nonatomic, readonly) Bit6Address *address;

/*! A display name for the sender. */
@property (nonatomic, strong) NSString *displayName;

/*! State of the sender. Use it to remember custom properties like "last typed text". */
@property (nonatomic, strong, readonly) NSMutableDictionary *state;

/*! Gets the number of unread messages for the sender.
 @see currentConversation
 */
@property (nonatomic, readonly) NSNumber *badge;

/*! If set to YES then <[Bit6Conversation badge]> value will be set to 0 and the sender won't consider new messages to increment the value of <[Bit6Conversation badge]>. */
@property (nonatomic, getter=isCurrentConversation) BOOL currentConversation;

/*! Last message received or sent in the conversation. */
@property (nonatomic, strong, readonly) Bit6Message *lastMessage;

/*! Gets the current typing user as a <Bit6Address> object, if available. */
@property (nonatomic, strong) Bit6Address *typingAddress;

/*! Returns an NSComparisonResult value that indicates whether the conversation timestamp value is greater than, equal to, or less than a given conversation timestamp. 
 @param conversation The conversation to compare to the conversation timestamp's value. This value must not be nil.
 */
- (NSComparisonResult) compare:(Bit6Conversation*)conversation;

@end
