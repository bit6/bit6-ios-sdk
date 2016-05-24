//
//  ProgressWindow.h
//  Bit6UI
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*! Nice UIWindow to dim the screen and block the user interaction when an operation is in progress. */
@interface BXUProgressWindow : NSObject

/*! Show the BXUProgressWindow with a custom text.
 @param title text to show in the window
 */
+ (void)showWithTitle:(nullable NSString*)title;

/*! Dismiss the BXUProgressWindow.
 @param completion block to execute when the BXUProgressWindow is dismissed. This block will be called in the main thread.
 */
+ (void)dismissWithHandler:(nullable void (^)())completion;

@end
