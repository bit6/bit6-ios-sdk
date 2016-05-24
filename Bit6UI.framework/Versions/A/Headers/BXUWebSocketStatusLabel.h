//
//  BXUWebSocketConnectingLabel.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/02/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXUWebSocketStatusLabelDelegate;

/*! Convenience subclass of UILabel to show the status of the signaling websocket. */
@interface BXUWebSocketStatusLabel : UILabel

/*! The delegate to be notified when the websocket label has change state. For details about the methods that can be implemented by the delegate, see <BXUWebSocketStatusLabelDelegate> Protocol Reference. */
@property (nullable, weak, nonatomic) IBOutlet id<BXUWebSocketStatusLabelDelegate> delegate;

/*! Views to show while the websocket status is "connecting". */
@property (nullable, strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView*>* viewsWhileConnecting __attribute__((deprecated));

/*! Views to show while the websocket status is "connected". */
@property (nullable, strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView*>* viewsWhenConnected __attribute__((deprecated));

/*! The label will be hidden when the websocket is "connected". */
@property (nonatomic) BOOL hideWhenConnected;

@end

/*! The BXUWebSocketStatusLabelDelegate protocol defines the methods a delegate of a <BXUWebSocketStatusLabel> object should implement. The methods of this protocol notify the delegate when the websocket label has change state. */
@protocol BXUWebSocketStatusLabelDelegate <NSObject>

/*! Called when the websocket label has change state.
 @param webSocketLabel websocket label
 @param status new state for the websocket label
 */
- (void)webSocketLabel:(nonnull BXUWebSocketStatusLabel*)webSocketLabel didChangeToStatus:(Bit6RTStatus)status;

@end