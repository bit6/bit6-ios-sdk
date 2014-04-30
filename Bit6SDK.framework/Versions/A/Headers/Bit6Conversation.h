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
    Bit6Conversation *conversation = [[Bit6Conversation alloc] initWithAddress:address];
 
 */
@interface Bit6Conversation : NSObject

/*! Initialize a Bit6Conversation object.
 * @param address <Bit6Address> object for the conversation.
 * @return the Bit6Conversation object.
 */
- (instancetype)initWithAddress:(Bit6Address*)address;

/*! The <Bit6Message> objects in the conversation as a NSArray. */
@property (nonatomic, readonly) NSArray *messages;

/*! The <Bit6Address> object associated with this conversation. */
@property (nonatomic, readonly) Bit6Address *address;

/*! Convenience method to obtain the existing conversations.
 * @return the existing Bit6Conversation objects as a NSArray.
 */
+ (NSArray*) conversations;

/*! Adds a conversation to the system.
 * @param conversation a Bit6Conversation object to be added.
 */
+ (void) addConversation:(Bit6Conversation*)conversation;

/*! Delete a conversation from the system. All the messages inside the conversation are deleted too.
 * @param conversation Bit6Conversation object to be deleted
 */
+ (void) deleteConversation:(Bit6Conversation*)conversation;

@end
