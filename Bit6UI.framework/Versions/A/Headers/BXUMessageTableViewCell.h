//
//  BXUMessageTableViewCell.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/29/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Unique cell to be used in <BXUMessageTableViewController>. */
@interface BXUMessageTableViewCell : UITableViewCell

/*! Font for the text content of the message. */
@property (nonatomic) UIFont *textFont UI_APPEARANCE_SELECTOR;

/*! Font for the datetime label shown between messages. */
@property (nonatomic) UIFont *datetimeFont UI_APPEARANCE_SELECTOR;

/*! Font for the datetime label shown between messages. */
@property (nonatomic) UIFont *displayNameFont UI_APPEARANCE_SELECTOR;

/*! Font for the time in audio recording attachments. */
@property (nonatomic) UIFont *audioTimerFont UI_APPEARANCE_SELECTOR;

/*! Font for the message status. */
@property (nonatomic) UIFont *statusFont UI_APPEARANCE_SELECTOR;

/*! TextColor inside the incoming message bubbles. */
@property (nonatomic) UIColor *incomingBubbleTextColor UI_APPEARANCE_SELECTOR;

/*! TextColor inside the outgoing message bubbles. */
@property (nonatomic) UIColor *outgoingBubbleTextColor UI_APPEARANCE_SELECTOR;

/*! TextColor for the datetime label shown between messages. */
@property (nonatomic) UIColor *datetimeTextColor UI_APPEARANCE_SELECTOR;

/*! TextColor for the datetime label shown between messages. */
@property (nonatomic) UIColor *displayNameTextColor UI_APPEARANCE_SELECTOR;

/*! TextColor for the message status. */
@property (nonatomic) UIColor *statusTextColor UI_APPEARANCE_SELECTOR;

/*! BackgroundColor for the incoming message bubbles. */
@property (nonatomic) UIColor *incomingBubbleViewBackgroundColor UI_APPEARANCE_SELECTOR;

/*! BackgroundColor for the outgoing message bubbles. */
@property (nonatomic) UIColor *outgoingBubbleViewBackgroundColor UI_APPEARANCE_SELECTOR;

/*! TintColor for the play and stop images in audio recording attachments. */
@property (nonatomic) UIColor *playVideoButtonTintColor UI_APPEARANCE_SELECTOR;

/*! TrackTintColor for the UIProgressView in audio recording attachments in incoming messages. */
@property (nonatomic) UIColor *incomingProgressViewTrackTintColor UI_APPEARANCE_SELECTOR;

/*! TrackTintColor for the UIProgressView in audio recording attachments in outgoing messages. */
@property (nonatomic) UIColor *outgoingProgressViewTrackTintColor UI_APPEARANCE_SELECTOR;

/*! TintColor for the UIProgressView in audio recording attachments in incoming messages. */
@property (nonatomic) UIColor *incomingProgressViewTintColor UI_APPEARANCE_SELECTOR;

/*! TintColor for the UIProgressView in audio recording attachments in outgoing messages. */
@property (nonatomic) UIColor *outgoingProgressViewTintColor UI_APPEARANCE_SELECTOR;

@end
