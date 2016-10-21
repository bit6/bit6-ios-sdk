//
//  BXUThumbnailImageView.h
//  Bit6UI
//
//  Created by Carlos Thurber on 01/01/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BXUAttachmentImageViewDelegate;

/*! Convenience subclass of UIImageView to work with the message's attachments. It can be set to show the message's thumbnail or to show an image attached to the message. 
 */
@interface BXUAttachmentImageView : UIImageView

/*! Sets the message for the sender.
 @param message message with an attachment to display.
 @param thumbnailMode if YES the sender will display the thumbnail for the message. If NO the sender will show the image attached to the message.
 */
- (void)setMessage:(Bit6Message*)message thumbnailMode:(BOOL)thumbnailMode;

/*! Reference to the message linked to the sender. */
@property (nullable, strong, nonatomic, readonly) Bit6Message* message;

/*! The delegate to be notified when the imageview  has been tapped. For details about the methods that can be implemented by the delegate, see <BXUAttachmentImageViewDelegate> Protocol Reference. */
@property (nullable, weak, nonatomic) id<BXUAttachmentImageViewDelegate> delegate;

@end

/*! The BXUAttachmentImageViewDelegate protocol defines the methods a delegate of a <BXUAttachmentImageView> object should implement. The methods of this protocol notify the delegate when the imageview  has been tapped. */
@protocol BXUAttachmentImageViewDelegate <NSObject>

/*! Notifies the delegate that the imageView has been tapped by the user for a message with an image attached.
 @param attachmentImageView The <BXUAttachmentImageView> object tapped by the user.
 @param message the message associated with the imageView.
 */
- (void)attachmentImageView:(nullable BXUAttachmentImageView*)attachmentImageView didSelectImageMessage:(Bit6Message*)message;

/*! Notifies the delegate that the imageView has been tapped by the user for a message with a video attached.
 @param attachmentImageView The <BXUAttachmentImageView> object tapped by the user.
 @param message the message associated with the imageView.
 */
- (void)attachmentImageView:(nullable BXUAttachmentImageView*)attachmentImageView didSelectVideoMessage:(Bit6Message*)message;

/*! Notifies the delegate that the imageView has been tapped by the user for a message with a location attached.
 @param attachmentImageView The <BXUAttachmentImageView> object tapped by the user.
 @param message the message associated with the imageView.
 */
- (void)attachmentImageView:(nullable BXUAttachmentImageView*)attachmentImageView didSelectLocationMessage:(Bit6Message*)message;

/*! Notifies the delegate that the imageView has been tapped by the user for a message with an audio attached.
 @param attachmentImageView The <BXUAttachmentImageView> object tapped by the user.
 @param message the message associated with the imageView.
 */
- (void)attachmentImageView:(nullable BXUAttachmentImageView*)attachmentImageView didSelectAudioMessage:(Bit6Message*)message;

@end

NS_ASSUME_NONNULL_END
