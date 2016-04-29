//
//  BXUConversationTableViewCell.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/22/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Unique cell to be used in <BXUConversationTableViewController>. */
@interface BXUConversationTableViewCell : UITableViewCell

/*! Set to YES to hide the avatar imageView in the cell. */
@property (nonatomic) BOOL hideAvatar UI_APPEARANCE_SELECTOR;

/*! Font for the title label. */
@property (nullable, strong, nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;

/*! Font for the last message label. */
@property (nullable, strong, nonatomic) UIFont *lastMessageFont UI_APPEARANCE_SELECTOR;

/*! In group conversations, font for the sender name of the last message. */
@property (nullable, strong, nonatomic) UIFont *otherForGroupFont UI_APPEARANCE_SELECTOR;

/*! Font for the timestamp label. */
@property (nullable, strong, nonatomic) UIFont *timestampFont UI_APPEARANCE_SELECTOR;

/*! TextColor for the title label. */
@property (nullable, strong, nonatomic) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;

/*! TextColor for the last message label. */
@property (nullable, strong, nonatomic) UIColor *lastMessageTextColor UI_APPEARANCE_SELECTOR;

/*! In group conversations, textColor for the sender name of the last message. */
@property (nullable, strong, nonatomic) UIColor *otherForGroupTextColor UI_APPEARANCE_SELECTOR;

/*! TextColor for the timestamp label. */
@property (nullable, strong, nonatomic) UIColor *timestampTextColor UI_APPEARANCE_SELECTOR;

@end
