//
//  BXUContactSource.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/15/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BXUContactSourceChangedNotification @"BXUContactSourceChanged"

/*! Contact model that contains all the information for an identity. */
@protocol BXUContact <NSObject>

/*! Identity URI for the contact. */
- (nonnull NSString*)uri;

/*! Display name for the contact. */
- (nonnull NSString*)name;

/*! URL for the contact's avatar. */
- (nullable NSURL*)avatarURL;

@optional
/*! Initials to show in the <BXUContactAvatarImageView> and <BXUConversationAvatarView> when the contact's avatar is not loaded. */
- (nullable NSString*)initials;

@end

/*! Data Source to provide the display names and avatars for each identity through the framework. */
@protocol BXUContactSource <NSObject>

/*! Called to retrieve a BXUContact for an identity.
 @param uri URI identity of the contact.
 @return contact matching the URI provided.
 */
- (nullable id<BXUContact>)contactForURI:(nonnull NSString*)uri;

@optional
/*! Called to retrieve BXUContact objects based on a string.
 @param string string to obtain BXUContact objects
 @return contacts matching the string provided.
 */
- (nonnull NSArray<id<BXUContact>>*)matchContactsForString:(nonnull NSString*)string;

@end
