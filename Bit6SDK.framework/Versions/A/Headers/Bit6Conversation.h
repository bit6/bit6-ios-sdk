//
//  Bit6Conversation.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Address.h"

/*! Bit6Conversation represents a conversation (or a chat) - a set of messages between two participants.
 
 How to create a conversation object:
 
    Bit6Address *address = [[Bit6Address alloc] initWithKind:Bit6AddressKind_USERNAME value:@"user2"];
    Bit6Conversation *conversation = [Bit6Conversation conversationWithAddress:address];
 
 */
@interface Bit6Conversation : NSObject

/*! Initialize a Bit6Conversation object.
 @note Deprecated: Please use <+[Bit6Conversation conversationWithAddress:]> instead
 @param address <Bit6Address> object for the conversation.
 @return the Bit6Conversation object.
 */
- (instancetype)initWithAddress:(Bit6Address*)address __attribute__((deprecated("Please use +[Bit6Conversation conversationWithAddress:] instead")));

/*! Returns a Bit6Conversation object based on the <Bit6Address> indicated. If the conversation didn't exists a new one will be created.
 @param address <Bit6Address> object for the conversation.
 @return a Bit6Conversation object for the <Bit6Address> indicated.
 */
+ (Bit6Conversation*) conversationWithAddress:(Bit6Address*)address;

/*! The <Bit6Message> objects in the conversation as a NSArray. */
@property (nonatomic, readonly) NSArray *messages;

/*! The <Bit6Address> object associated with this conversation. */
@property (nonatomic, readonly) Bit6Address *address;

/*! Convenience method to obtain the existing conversations.
 @return the existing Bit6Conversation objects as a NSArray.
 @note Deprecated: Please use <+[Bit6 conversations]> instead
 */
+ (NSArray*) conversations __attribute__((deprecated("Please use +[Bit6 conversations] instead")));

/*! Adds a conversation to the system.
 @param conversation a Bit6Conversation object to be added.
 @note Deprecated: Please use <+[Bit6 addConversation:]> instead
 */
+ (void) addConversation:(Bit6Conversation*)conversation __attribute__((deprecated("Please use +[Bit6 addConversation:] instead")));

/*! Delete a conversation from the system. All the messages inside the conversation are deleted too.
 @param conversation Bit6Conversation object to be deleted
 @note Deprecated: Please use <+[Bit6 deleteConversation:]> instead
 */
+ (void) deleteConversation:(Bit6Conversation*)conversation __attribute__((deprecated("Please use +[Bit6 deleteConversation:] instead")));

/*! A display name for the destination in this <Bit6Conversation> object. */
@property (nonatomic, readonly) NSString *displayName;

/*! Gets the number of unread messages for this conversation. 
 @see ignoreBadge
 */
@property (nonatomic, readonly) NSNumber *badge;

/*! If set to YES then <[Bit6Conversation badge]> value will be set to 0 and the conversation won't consider new messages in this conversation to increment the value of <[Bit6Conversation badge]>. */
@property (nonatomic) BOOL ignoreBadge;

@end