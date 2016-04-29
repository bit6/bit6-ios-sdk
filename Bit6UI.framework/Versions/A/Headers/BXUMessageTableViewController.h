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

/*! Component to show all the messages in one conversation, or all the messages for all conversations at the same time. It includes support to send/receive messages with attachments and make calls. */
@interface BXUMessageTableViewController : UIViewController

/*! Reference to the title label in self.navigationItem.titleView */
@property (nullable, weak, nonatomic, readonly) BXUContactNameLabel *titleLabel;

/*! Reference to the typing label in self.navigationItem.titleView */
@property (nullable, weak, nonatomic, readonly) BXUTypingLabel *typingLabel;

/*! Reference to the call button item in self.navigationItem.rightBarButtonItem */
@property (nonnull, strong, nonatomic, readonly) UIBarButtonItem *callButtonItem;

/*! Identity to apply to this component. */
@property (nonnull, strong, nonatomic) Bit6Address *address;

/*! Identity to apply only to the table view. This identity will be use to set which messages to show in the table. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (nullable, strong, nonatomic) Bit6Address *tableViewAddress;

/*! Identity to apply only to the compose panel. This identity will be use to set the destination of the outgoing messages. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (nonnull, strong, nonatomic) Bit6Address *composePanelAddress;

/*! Identity to apply only to the call button. This identity will be use to determine the contact to call. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (nonnull, strong, nonatomic) Bit6Address *callButtonAddress;

/*! Identity to apply only to the title label. This identity will be use to determine the title of the view controller. 
 @note You usually don't need to set this property because it is set to the same value as <BXUMessageTableViewController.address>
 */
@property (nonnull, strong, nonatomic) Bit6Address *titleLabelAddress;

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
- (void)didSelectImageMessage:(nonnull Bit6Message*)message;

/*! Called after an video attachment has been tapped. The default implementation does nothing. You usually override this method to perform additional operations. 
 @param message message of the attachment tapped.
 */
- (void)didSelectVideoMessage:(nonnull Bit6Message*)message;

/*! Called after an location attachment has been tapped. The default implementation does nothing. You usually override this method to perform additional operations. 
 @param message message of the attachment tapped.
 */
- (void)didSelectLocationMessage:(nonnull Bit6Message*)message;

@end
