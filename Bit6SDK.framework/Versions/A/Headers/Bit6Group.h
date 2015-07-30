//
//  Bit6Group.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/10/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Address.h"
#import "Bit6Conversation.h"
#import "Bit6Constants.h"

extern NSString* const Bit6EmptyGroupSubject;

extern NSString* const Bit6GroupMemberRole_Admin;
extern NSString* const Bit6GroupMemberRole_User;
extern NSString* const Bit6GroupMemberRole_Left;

extern NSString* const Bit6GroupMetadataTitleKey;

@class Bit6GroupPermissions;
@class Bit6GroupMember;

/*! A Bit6Group object represents a group formed by several users. */
@interface Bit6Group : NSObject

/*! Returns a Bit6Group object based on the <Bit6Address> indicated.
 @param address <Bit6Address> of the group.
 @return a Bit6Group object for the <Bit6Address> indicated.
 */
+ (Bit6Group*) groupForAddress:(Bit6Address*)address;

/*! Returns a Bit6Group object based on the <Bit6Conversation> indicated.
 @param conversation <Bit6Conversation> linked to the group.
 @return a Bit6Group object for the <Bit6Conversation> indicated.
 */
+ (Bit6Group*) groupForConversation:(Bit6Conversation*)conversation;

/*! Creates an empty group.
 @param metadata metadata for the new group.
 @param completion block to be called when the operation is completed.
 */
+ (void) createGroupWithMetadata:(NSDictionary*)metadata completion:(void (^)(Bit6Group *group, NSError *error))completion;

/*! Creates an empty public group with the specified identifier.
 @param identifier unique identifier to use
 @param metadata metadata for the new group.
 @param completion block to be called when the operation is completed.
 */
+ (void) createPublicGroupWithIdentifier:(NSString*)identifier metadata:(NSDictionary*)metadata completion:(void (^)(Bit6Group *group, NSError *error))completion;

/*! Join a public group.
 @param address <Bit6Address> of the group to join.
 @param completion block to be called when the operation is completed.
 @note You can check if a group is public by using <[Bit6Group isPublic]>
 */
+ (void) joinGroupWithAddress:(Bit6Address*)address completion:(void (^)(Bit6Group *group, NSError *error))completion;

/*! Sets the metadata for the sender.
 @param metadata new metadata for the sender.
 @param completion block to be called when the operation is completed.
 */
- (void) setMetadata:(NSDictionary*)metadata completion:(void (^)(NSError *error))completion;

/*! Abandon the sender. Updates related to the sender won't be received anymore.
 @param completion block to be called when the operation is completed.
 */
- (void) leaveGroupWithCompletion:(void (^)(NSError *error))completion;

/*! The <Bit6Address> object associated with the sender. */
@property (nonatomic, readonly) Bit6Address *address;
/*! The creation timestamp of the sender. */
@property (nonatomic, copy, readonly) NSNumber *created;
/*! The last updated timestamp of the sender. */
@property (nonatomic, copy, readonly) NSNumber *updated;
/*! The sender subject. */
@property (nonatomic, copy, readonly) NSDictionary *metadata;
/*! The <Bit6GroupMember> objects in the sender as a NSArray. */
@property (nonatomic, copy, readonly) NSArray *members;
/*! YES if the user role in the group is Admin. */
@property (nonatomic, readonly) BOOL isAdmin;
/*! YES if the user has left the group. */
@property (nonatomic, readonly) BOOL hasLeft;
/*! YES if the group is public. */
@property (nonatomic, readonly) BOOL isPublic;

/*! Refreshes the members of the sender.
 @param completion block to be called when the operation is completed.
 @return current members list of the sender.
 */
- (NSArray*) loadMembersListWithCompletion:(void (^)(NSArray *members, NSError *error))completion;

/*! Invite users to the group.
 @param addresses array of <Bit6Address> indicating the users to invite.
 @param completion block to be called when the operation is completed.
 */
- (void) inviteAddresses:(NSArray*)addresses completion:(void (^)(NSArray *members, NSError *error))completion;

/*! Remove a member from the group.
 @param member member to be removed from the group.
 @param completion block to be called when the operation is completed.
 */
- (void) deleteMember:(Bit6GroupMember*)member completion:(void (^)(NSArray *members, NSError *error))completion;

@end

/*! A Bit6GroupMember object represents a member of a <Bit6Group> object. */
@interface Bit6GroupMember : NSObject

/*! The <Bit6Address> object associated with the sender. */
@property (nonatomic, copy, readonly) Bit6Address *address;
/*! The role of the sender inside the group. The return value can be one of three constants: Bit6GroupMemberRole_Admin, Bit6GroupMemberRole_User or Bit6GroupMemberRole_Left. */
@property (nonatomic, copy, readonly) NSString *role;
/*! The last seen timestamp of the sender. */
@property (nonatomic, copy, readonly) NSNumber *seen;
/*! The status of the sender. */
@property (nonatomic, copy, readonly) NSString *status;
/*! The conversation the sender belongs to. */
@property (nonatomic, copy, readonly) Bit6Group *group;

@end
