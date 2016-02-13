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

extern NSString* _Nonnull const Bit6GroupMemberRole_Admin;
extern NSString* _Nonnull const Bit6GroupMemberRole_User;
extern NSString* _Nonnull const Bit6GroupMemberRole_Left;

extern NSString* _Nonnull const Bit6GroupMetadataTitleKey;

@class Bit6GroupPermissions;
@class Bit6GroupMember;

/*! A Bit6Group object represents a group formed by several users. */
@interface Bit6Group : NSObject

/*! Returns a Bit6Group object based on the <Bit6Address> indicated.
 @param address <Bit6Address> of the group.
 @return a Bit6Group object for the <Bit6Address> indicated.
 */
+ (nullable Bit6Group*)groupWithAddress:(nonnull Bit6Address*)address;

/*! Returns a Bit6Group object based on the <Bit6Conversation> indicated.
 @param conversation <Bit6Conversation> linked to the group.
 @return a Bit6Group object for the <Bit6Conversation> indicated.
 */
+ (nullable Bit6Group*)groupWithConversation:(nonnull Bit6Conversation*)conversation;

/*! Creates an empty group.
 @param metadata metadata for the new group. If provided it has to be able to be converted to JSON data (check by using +[NSJSONSerialization isValidJSONObject:])
 @param completion block to be called when the operation is completed.
 */
+ (void)createGroupWithMetadata:(nullable NSDictionary<NSString*,id>*)metadata completion:(nullable void (^)(Bit6Group* _Nullable group, NSError* _Nullable error))completion;

/*! Creates an empty public group with the specified identifier.
 @param identifier unique identifier to use.
 @param metadata metadata for the new group. If provided it has to be able to be converted to JSON data (check by using +[NSJSONSerialization isValidJSONObject:])
 @param completion block to be called when the operation is completed.
 */
+ (void)createPublicGroupWithIdentifier:(nonnull NSString*)identifier metadata:(nullable NSDictionary<NSString*,id>*)metadata completion:(nullable void (^)(Bit6Group* _Nullable group, NSError* _Nullable error))completion;

/*! Join a public group.
 @param address <Bit6Address> of the group to join.
 @param role requested role in the group. There are constants available to use: Bit6GroupMemberRole_Admin and Bit6GroupMemberRole_User.
 @param completion block to be called when the operation is completed.
 @note You can check if a group is public by using <[Bit6Group isPublic]>
 */
+ (void)joinGroupWithAddress:(nonnull Bit6Address*)address role:(nonnull NSString*)role completion:(nullable void (^)(Bit6Group* _Nullable group, NSError* _Nullable error))completion;

/*! Sets the metadata for the sender. 
 @param metadata new metadata for the sender. If provided it has to be able to be converted to JSON data (check by using +[NSJSONSerialization isValidJSONObject:])
 @param completion block to be called when the operation is completed.
 */
- (void)setMetadata:(nonnull NSDictionary<NSString*,id>*)metadata completion:(nullable void (^)(NSError* _Nullable error))completion;

/*! Abandon the sender. Updates related to the sender won't be received anymore.
 @param completion block to be called when the operation is completed.
 */
- (void)leaveGroupWithCompletion:(nullable void (^)(NSError*  _Nullable error))completion;

/*! The <Bit6Address> object associated with the sender. */
@property (nonnull, nonatomic, readonly) Bit6Address *address;
/*! The creation timestamp of the sender. */
@property (nonnull, nonatomic, copy, readonly) NSNumber *created;
/*! The last updated timestamp of the sender. */
@property (nullable, nonatomic, copy, readonly) NSNumber *updated;
/*! The sender subject. */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString*,id>* metadata;
/*! The <Bit6GroupMember> objects in the sender as a NSArray. */
@property (nullable, nonatomic, copy, readonly) NSArray<Bit6GroupMember*>* members;
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
- (nullable NSArray<Bit6GroupMember*>*)loadMembersListWithCompletion:(nullable void (^)(NSArray<Bit6GroupMember*>* _Nullable members, NSError* _Nullable error))completion;

/*! Invite an user to the group.
 @param address <Bit6Address> indicating the user to invite.
 @param role requested role to assign to the user invited to the group. There are constants available to use: Bit6GroupMemberRole_Admin and Bit6GroupMemberRole_User.
 @param completion block to be called when the operation is completed.
 */
- (void)inviteGroupMemberWithAddress:(nonnull Bit6Address*)address role:(nonnull NSString*)role completion:(nullable void (^)(NSArray<Bit6GroupMember*>* _Nullable members, NSError* _Nullable error))completion;

/*! Invite users to the group.
 @param addresses array of <Bit6Address> indicating the users to invite.
 @param roles array of requested roles to assign to the users invited to the group. There are constants available to use: Bit6GroupMemberRole_Admin and Bit6GroupMemberRole_User.
 @param completion block to be called when the operation is completed.
 */
- (void)inviteGroupMembersWithAddresses:(nonnull NSArray<Bit6Address*>*)addresses roles:(nonnull NSArray<NSString*>*)roles completion:(nullable void (^)(NSArray<Bit6GroupMember*>* _Nullable members, NSError* _Nullable error))completion;

/*! Remove a member from the group.
 @param member member to be removed from the group.
 @param completion block to be called when the operation is completed.
 */
- (void)kickGroupMember:(nonnull Bit6GroupMember*)member completion:(nullable void (^)(NSArray<Bit6GroupMember*>* _Nullable members, NSError* _Nullable error))completion;

@end

/*! A Bit6GroupMember object represents a member of a <Bit6Group> object. */
@interface Bit6GroupMember : NSObject

/*! The <Bit6Address> object associated with the sender. */
@property (nonnull, nonatomic, copy, readonly) Bit6Address *address;
/*! The role of the sender inside the group. The return value can be one of three constants: Bit6GroupMemberRole_Admin, Bit6GroupMemberRole_User or Bit6GroupMemberRole_Left. */
@property (nonnull, nonatomic, copy, readonly) NSString *role;
/*! The last seen timestamp of the sender. */
@property (nullable, nonatomic, copy, readonly) NSNumber *seen;
/*! The status of the sender. */
@property (nullable, nonatomic, copy, readonly) NSString *status;
/*! The conversation the sender belongs to. */
@property (nonnull, nonatomic, copy, readonly) Bit6Group *group;
/*! The public profile of the group member. */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString*,id>* publicProfile;

@end
