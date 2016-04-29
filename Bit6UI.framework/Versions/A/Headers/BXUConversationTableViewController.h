//
//  BXUConversationTableViewController.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/28/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const BXUConversationSelectedNotification;

/*! Component to show all the conversations in the system. */
@interface BXUConversationTableViewController : UITableViewController

/*! Called after a conversation has been selected. The default implementation does nothing. You usually override this method to perform additional operations.
 @param conversation conversation selected.
 */
- (void)didSelectConversation:(Bit6Conversation*)conversation;

@end
