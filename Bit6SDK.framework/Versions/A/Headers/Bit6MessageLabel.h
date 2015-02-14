//
//  Bit6MessageLabel.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 08/12/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bit6Message.h"
#import "Bit6MenuControllerDelegate.h"

/*! Special subclass of UILabel to work with the text content included in a message. It includes a convenient UIMenuController if the Bit6MenuControllerDelegate is implemented. */
@interface Bit6MessageLabel : UILabel

/*! Message with an attachment to be displayed */
@property (nonatomic, copy) Bit6Message *message;

/*! the delegate to be notified when an option in the default UIMenuController in the Bit6MessageLabel is touched. */
@property (nonatomic, weak) id <Bit6MenuControllerDelegate> menuControllerDelegate;

@end
