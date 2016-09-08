//
//  BXUButtons.h
//  Bit6UI
//
//  Created by Carlos Thurber on 08/25/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Convenience subclass of UIButton with an ON-OFF status displayed as a circle. To be used in storyboards */
@interface BXUCircleButton : UIButton

/*! The ON/OFF status of the button. */
@property (nonatomic) BOOL on;

/*! Color to be used when the button is not enabled. */
@property (nonatomic, strong) UIColor *disableColor;

/*! Color to be used when the button is set to ON. */
@property (nonatomic, strong) UIColor *onColor;

/*! Color to be used when the button is highlighted. */
@property (nonatomic, strong) UIColor *highlightedColor;

/*! Color to be used when the button is enabled but set to OFF. */
@property (nonatomic, strong) UIColor *defaulBackgroundColor;

@end

/*! Convenience subclass of UIButton with rounded corners to be used in storyboards . */
@interface BXURoundedButton : UIButton
@end
