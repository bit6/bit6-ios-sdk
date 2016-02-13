//
//  Bit6MenuControllerDelegate.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 08/12/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6OutgoingMessage.h"

/*! The Bit6MenuControllerDelegate protocol defines methods that your delegate object must implement to allow the standard UIMenuController to be shown on a UIView element related to a <Bit6Message> with options like 'forward a sent message', 'send again a failed message' and 'copy text'. */
@protocol Bit6MenuControllerDelegate <NSObject>

@optional

/*! If implemented, the "forward" action will be available in the standard UIMenuController. Tells the delegate that the "forward" menu was pressed.
 @param msg The <Bit6Message> object to be forwarded.
 @note Important: The "forward" action is only available for messages sent. A duplicated of the message has to be built using Bit6OutgoingMessage.outgoingCopyOfMessage.
 */
- (void)forwardMessage:(nonnull Bit6Message*)msg;

/*! If implemented, the "send" action will be available in the standard UIMenuController. Tells the delegate that the "send" menu was pressed.
 @param msg The <Bit6Message> object to be send again.
 @note Important: The "send" action is only available for failed messages.
 */
- (void)resendFailedMessage:(nonnull Bit6OutgoingMessage*)msg;

@end
