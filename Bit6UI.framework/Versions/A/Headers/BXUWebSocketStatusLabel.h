//
//  BXUWebSocketConnectingLabel.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/02/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Convenience subclass of UILabel to show the status of the signaling websocket. */
@interface BXUWebSocketStatusLabel : UILabel

/*! Views to show while the websocket status is "connecting". */
@property (nullable, strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView*>* viewsWhileConnecting;

/*! Views to show while the websocket status is "connected". */
@property (nullable, strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView*>* viewsWhenConnected;

/*! Set to hide the label when the websocket is "connected". */
@property (nonatomic) BOOL hideWhenConnected;

@end
