//
//  BXUImageViewController.h
//  Bit6UI
//
//  Created by Carlos Thurber on 01/14/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXUImageViewControllerDelegate;

/*! Convenience subclass of UIViewController to display an image attached to a message. 
 @discussion This viewController will present an UITabBar with options to share the image. 
 */
@interface BXUImageViewController : UIViewController

/*! Sets the message for the sender. 
 @param message a message with an image attachment to show in the sender.
 */
- (void)setMessage:(nonnull Bit6Message*)message;

/*! The delegate to be notified when the viewcontroller has to be dismissed. For details about the methods that can be implemented by the delegate, see <BXUImageViewControllerDelegate> Protocol Reference. */
@property (nullable, weak, nonatomic) id<BXUImageViewControllerDelegate> delegate;

@end

/*! The BXUImageViewControllerDelegate protocol defines the methods a delegate of a <BXUImageViewController> object should implement. The methods of this protocol notify the delegate when the viewcontroller has to be dismissed. */
@protocol BXUImageViewControllerDelegate <NSObject>

/*! Called when the user decide to dismiss the viewcontroller. It is necessary to implement this method to dismiss this viewcontroller.
 @param imageViewController view controller to dismiss
 */
- (void)dismissImageViewController:(nonnull BXUImageViewController*)imageViewController;

@end