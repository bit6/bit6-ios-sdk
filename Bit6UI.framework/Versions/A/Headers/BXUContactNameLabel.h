//
//  BXUContactNameLabel.h
//  Bit6UI
//
//  Created by Carlos Thurber on 11/19/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Convenience subclass of UILabel to show the display name for a contact. This class work together with <BXUContactSource> to know the display name to show.
 @see <BXUContactSource>
 */
@interface BXUContactNameLabel : UILabel

/*! Identity of the contact for this label. */
@property (nullable, strong, nonatomic) Bit6Address *address;

@end
