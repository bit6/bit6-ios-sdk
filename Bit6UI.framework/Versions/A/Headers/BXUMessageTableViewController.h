//
//  BXUMessageTableViewController.h
//  Bit6UI
//
//  Created by Carlos Thurber on 01/12/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXUContactNameLabel.h"
#import "BXUTypingLabel.h"

NS_ASSUME_NONNULL_BEGIN

/*! Component to show all the messages in one conversation, or all the messages for all conversations at the same time. It includes support to send/receive messages with attachments and make calls. */
@interface BXUMessageTableViewController : UIViewController <UIViewControllerPreviewingDelegate>

/*! Reference to the tableView */
@property (strong, nonatomic, readonly) UITableView *tableView;

/*! List of messages showing in the tableView */
@property (nullable, strong, nonatomic, readonly) NSArray<Bit6Message*>* messages;

/*! Set this property to YES when creating this viewController to disable PeekAndPop in the attachment thumbnails. */
@property (nonatomic) BOOL peekAndPopDisabled;

/*! Reference to the title label in self.navigationItem.titleView */
@property (nullable, weak, nonatomic, readonly) BXUContactNameLabel *titleLabel;

/*! Reference to the typing label in self.navigationItem.titleView */
@property (nullable, weak, nonatomic, readonly) BXUTypingLabel *typingLabel;

/*! Reference to the call button item in self.navigationItem.rightBarButtonItem */
@property (strong, nonatomic, readonly) UIBarButtonItem *callButtonItem;

/*! Used to enable sending video attachments in the conversation. By default is YES. */
@property (nonatomic) BOOL enableVideoAttachments;

/*! Used to enable sending photo attachments in the conversation. By default is YES. */
@property (nonatomic) BOOL enablePhotoAttachments;

/*! Used to enable sending the current location in the conversation. By default is YES. */
@property (nonatomic) BOOL enableLocationAttachments;

/*! Used to enable sending audio recordings in the conversation. By default is YES. */
@property (nonatomic) BOOL enableAudioAttachments;

/*! Identity to apply to this component. */
@property (strong, nonatomic) Bit6Address *address;

/*! Used to show emojis in the conversation without a bubble, in a bigger font. This will only apply if there's one single emoji, without any additional text. By default is NO. */
@property (nonatomic) BOOL biggerEmojis;

/*! Identity to apply only to the table view. This identity will be use to set which messages to show in the table. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (nullable, strong, nonatomic) Bit6Address *tableViewAddress;

/*! Identity to apply only to the compose panel. This identity will be use to set the destination of the outgoing messages. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (strong, nonatomic) Bit6Address *composePanelAddress;

/*! Identity to apply only to the call button. This identity will be use to determine the contact to call. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (strong, nonatomic) Bit6Address *callButtonAddress;

/*! Identity to apply only to the title label. This identity will be use to determine the title of the view controller. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (strong, nonatomic) Bit6Address *titleLabelAddress;

/*! Identity to apply only to the typing label. This identity will be use to detect when a contact is typing. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (nullable, strong, nonatomic) Bit6Address *typingLabelAddress;

/*! Maximum allowed duration (in seconds) of the audio files to be recorded. */
@property (nonatomic) CGFloat audioMaxDuration;

/*! Maximum allowed duration (in seconds) of the video files to be sent. */
@property (nonatomic) CGFloat videoMaxDuration;

/*! Called after an image attachment has been tapped. The default implementation does nothing. You usually override this method to perform additional operations. 
 @param message message of the attachment tapped.
 */
- (void)didSelectImageMessage:(Bit6Message*)message;

/*! Called after an video attachment has been tapped. The default implementation does nothing. You usually override this method to perform additional operations. 
 @param message message of the attachment tapped.
 */
- (void)didSelectVideoMessage:(Bit6Message*)message;

/*! Called after an location attachment has been tapped. The default implementation does nothing. You usually override this method to perform additional operations. 
 @param message message of the attachment tapped.
 */
- (void)didSelectLocationMessage:(Bit6Message*)message;

@end
NS_ASSUME_NONNULL_END
