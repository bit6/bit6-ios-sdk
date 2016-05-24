//
//  BXUTypingLabel.h
//  Bit6UI
//
//  Created by Carlos Thurber on 11/16/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXUTypingLabelDelegate;

/*! Convenience subclass of UILabel to show when another user is typing. */
@interface BXUTypingLabel : UILabel

/*! Identity of the contact to detect when typing, or nil to work with any contact. */
@property (nullable, strong, nonatomic) Bit6Address *address;

/*! The delegate to be notified when the typing label will become visible or hidden. For details about the methods that can be implemented by the delegate, see <BXUTypingLabelDelegate> Protocol Reference. */
@property (nullable, weak, nonatomic) IBOutlet id<BXUTypingLabelDelegate> delegate;

@end

/*! The BXUTypingLabelDelegate protocol defines the methods a delegate of a <BXUTypingLabel> object should implement. The methods of this protocol notify the delegate when the typing label will become visible or hidden. */
@protocol BXUTypingLabelDelegate <NSObject>

/*! Called when the typing label is going to be shown.
 @param typingLabel typing label to be shown
 */
- (void)showTypingLabel:(nonnull BXUTypingLabel*)typingLabel;

/*! Called when the typing label is going to be hidden.
 @param typingLabel typing label to be hidden
 */
- (void)hideTypingLabel:(nonnull BXUTypingLabel*)typingLabel;

@end