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
#import "BXUIncomingCallPrompt.h"
#import "BXUProgressWindow.h"

#define BIT6UI_IOS_SDK_VERSION_STRING @"0.9.7"

/*! BXU offers some generic functionality like setting the ContactDataSource to use through the framework, to show incoming message banners and deletion of cache pictures. */
@interface BXU : NSObject

/*! Gets the current <BXUContactSource> object.
 @return contact source object.
 */
+ (nullable id<BXUContactSource>)contactSource;

/*! Sets the current <BXUContactSource> object to use through the framework.
 @note After a logout this value will be set to nil automatically.
 @param contactDataSource contact source object to set.
 */
+ (void)setContactSource:(nullable id<BXUContactSource>)contactDataSource;

/*! Deletes the profile pictures from cache.
 @return number of files deleted.
 */
+ (NSUInteger)clearProfilePictures;

/*! Deletes an identity profile picture from cache.
 @param address identity of the profile picture to delete.
 @return YES if the file was deleted from cache.
 */
+ (BOOL)clearProfilePictureForAddress:(nonnull Bit6Address*)address;

/*! Shows a incoming message notification banner.
 @param from identity to use as the sender of the message.
 @param message message to show in the banner
 @param tappedHandler handler to execute if the banner is tapped
 @return YES if the file was deleted from cache.
 */
+ (void)showNotificationFrom:(nonnull Bit6Address*)from message:(nonnull NSString*)message tappedHandler:(nullable void(^)(Bit6Address * _Nullable from))tappedHandler;

@end
