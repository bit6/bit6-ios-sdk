//
//  BXU.h
//  Bit6UI
//
//  Created by Carlos Thurber on 11/06/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#ifndef _BIT6UI_H
#define _BIT6UI_H
#endif

#ifndef _BIT6_H
@import Bit6;
#endif

#import <UIKit/UIKit.h>

#import "BXUContactSource.h"

#import "BXUContactNameLabel.h"
#import "BXUConversationAvatarView.h"
#import "BXUContactAvatarImageView.h"

#import "BXUTypingLabel.h"
#import "BXUWebSocketStatusLabel.h"

#import "BXUAttachmentImageView.h"
#import "BXUImageViewController.h"
#import "BXULocationViewController.h"

#import "BXUConversationTableViewController.h"
#import "BXUConversationTableViewCell.h"
#import "BXUMessageTableViewController.h"
#import "BXUMessageTableViewCell.h"

#import "BXUConversationsTabBarItem.h"
#import "BXUCallViewController.h"
#import "BXUIncomingCallPrompt.h"
#import "BXUProgressWindow.h"

#import "BXUButtons.h"

#define BIT6UI_IOS_SDK_VERSION_STRING @"0.10.1"

NS_ASSUME_NONNULL_BEGIN

/*! BXU offers some generic functionality like setting the ContactDataSource to use through the framework, to show incoming message banners and deletion of cache pictures. */
@interface BXU : NSObject

/*! Unavailable init
 @return a new instance of the class.
 */
- (instancetype)init NS_UNAVAILABLE;

/*! Gets the current <BXUContactSource> object.
 @return contact source object.
 */
+ (nullable id<BXUContactSource>)contactSource;

/*! Sets the current <BXUContactSource> object to use through the framework.
 @note After a logout this value will be set to nil automatically.
 @param contactDataSource contact source object to set.
 */
+ (void)setContactSource:(nullable id<BXUContactSource>)contactDataSource;

/*! Returns the display name for an specified identity. If no contact is provided for the identity in the +[BXU contactSource] then a default display name will be generated.
 @param address identity to search for an display name.
 @return display name for the identity.
 @see +[BXU contactSource]
 */
+ (NSString*)displayNameForAddress:(Bit6Address*)address;

/*! Returns the name initials for an specified identity.
 @param address identity to search for the name initials.
 @return name initials for the identity.
 @see +[BXU displayNameForAddress:]
 @see +[BXU contactSource]
 */
+ (NSString*)initialsForAddress:(Bit6Address*)address;

/*! Returns the image URL for an specified identity.
 @param address identity to search for the image URL.
 @return image URL for the identity.
 @see +[BXU contactSource]
 */
+ (nullable NSURL*)displayImageURLForAddress:(Bit6Address*)address;

/*! Deletes the profile pictures from cache.
 @return number of files deleted.
 */
+ (NSUInteger)clearProfilePictures;

/*! Deletes an identity profile picture from cache.
 @param address identity of the profile picture to delete.
 @return YES if the file was deleted from cache.
 */
+ (BOOL)clearProfilePictureForAddress:(Bit6Address*)address;

/*! Shows a incoming message notification banner.
 @param from identity to use as the sender of the message.
 @param message message to show in the banner
 @param tappedHandler handler to execute if the banner is tapped
 */
+ (void)showNotificationFrom:(Bit6Address*)from message:(NSString*)message tappedHandler:(nullable void(^)(Bit6Address * _Nullable from))tappedHandler;

///---------------------------------------------------------------------------------------
/// @name ￼Calls
///---------------------------------------------------------------------------------------

/*! The current call media mode. */
+ (Bit6CallMediaMode)callMediaMode;

/*! Indicates if the calls will go P2P or if the server should process the media.
 @param callMediaMode P2P or MIX to process the calls media in the server.
 */
+ (void)setCallMediaMode:(Bit6CallMediaMode)callMediaMode;

/*! The current configuration for audio calls support. 
 @return YES if audio calls are enabled.
 */
+ (BOOL)enableAudioCalls;

/*! Used to configure the support for audio streams in the calls.
 @param enable YES if audio streams should be available during the calls.
 */
+ (void)setEnableAudioCalls:(BOOL)enable;

/*! The current configuration for video calls support.
 @return YES if video calls are enabled.
 */
+ (BOOL)enableVideoCalls;

/*! Used to configure the support for video streams in the calls.
 @param enable YES if video streams should be available during the calls.
 */
+ (void)setEnableVideoCalls:(BOOL)enable;

/*! The current configuration for data transfers during a call.
 @return YES if data transfer should be enabled in the calls.
 */
+ (BOOL)enableCallsWithData;

/*! Used to configure the support for data transfers in the calls.
 @param enable YES if data transfers should be available during the calls.
 */
+ (void)setEnableCallsWithData:(BOOL)enable;

/*! Convenient method to get the enabled streams in Bit6UI framework from a given streams param.
 @param streams the list of streams we want to compare.
 @return the enabled streams in the given streams param.
 */
+ (Bit6CallStreams)availableStreamsIn:(Bit6CallStreams)streams;

@end

NS_ASSUME_NONNULL_END
