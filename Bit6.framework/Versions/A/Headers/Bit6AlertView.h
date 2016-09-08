//
//  Bit6AlertView.h
//  Bit6
//
//  Created by Carlos Thurber on 08/29/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*! Convenient class to show a UIAlertController of Alert style convering the entire screen. */
@interface Bit6AlertView : NSObject

/*! Show a default Bit6AlertView. 
 @param title The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
 @param message Descriptive text that provides additional details about the reason for the alert.
 @param cancelButtonTitle title of the cancel button to dismiss the alert.
 @return a reference to the Bit6AlertView shown.
 */
+ (Bit6AlertView*)showAlertControllerWithTitle:(nullable NSString*)title message:(nullable NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle;

/*! Creates Bit6AlertView with a title and a message.
 @param title The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
 @param message Descriptive text that provides additional details about the reason for the alert.
 @return the new Bit6AlertView object.
 */
+ (Bit6AlertView*)alertControllerWithTitle:(nullable NSString*)title message:(nullable NSString*)message;

/*! Convenient method to add an additional button with Cancel style to the UIAlertController object. 
 @param cancelButtonTitle title for the cancel button. */
- (void)addCancelButtonWithTitle:(NSString*)cancelButtonTitle;

/*! Shows the Bit6AlertView convering the entire screen. */
- (void)show;

/*! Dismiss the Bit6AlertView. Every UIAlertAction added to the Bit6AlertView must call this method at the end of its handler.*/
- (void)dismiss;

///---------------------------------------------------------------------------------------
/// @name ￼UIAlertController
///---------------------------------------------------------------------------------------

/*! Reference to the internal UIAlertController object.*/
@property (nonatomic, strong, readonly) UIAlertController *alertController;

/*! Attaches an action object to the alert or action sheet.
 @param action The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
 */
- (void)addAction:(UIAlertAction *)action;

/*! Adds a text field to an alert.
 @param configurationHandler A block for configuring the text field prior to displaying the alert. This block has no return value and takes a single parameter corresponding to the text field object. Use that parameter to change the text field properties..
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

/*! The array of text fields displayed by the alert. */
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@end

NS_ASSUME_NONNULL_END