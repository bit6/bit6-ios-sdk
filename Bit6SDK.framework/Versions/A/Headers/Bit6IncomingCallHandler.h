//
//  Bit6IncomingCallHandler.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/09/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bit6CallViewController.h"

@protocol Bit6IncomingCallHandlerDelegate;

/*! Bit6IncomingCallHandler is used to handle the incoming calls. */
@interface Bit6IncomingCallHandler : NSObject

/*! The delegate to be called when an incoming cal is received to customize the flow. For details about the methods that can be implemented by the delegate, see <Bit6IncomingCallHandlerDelegate> Protocol Reference.
 */
@property (nonatomic, weak) id<Bit6IncomingCallHandlerDelegate>delegate;

@end

/*! The Bit6IncomingCallHandlerDelegate protocol defines the methods a delegate of the <Bit6IncomingCallHandler> object could implement to customize the behaviour when an incoming call is received.
 */
@protocol Bit6IncomingCallHandlerDelegate <NSObject>

@optional

/*! Implement to customize the view controller used to handle the incoming call.
 @return a view controller to be used during the incoming call.
 */
- (Bit6CallViewController*) inCallViewController;

/*! Implement to customize the view shown in the incoming call notification banner.
 @discussion  You should set this tags to your UI elements:
 <pre>
 title UILabel: tag=15
 message UILabel: tag=16
 decline UIButton: tag=17
 answer UIButton: tag=18
 </pre>
 @return a view to use in the incoming call notification banner.
 */
- (UIView*) incomingCallNotificationBannerContentView;

/*! Starting point of the incoming calls flow. Implement if you want to handle the entire flow.
 @param notification incoming call notification to be used with <[Bit6 callControllerFromIncomingCallNotification:]>
 */
- (void) receivedIncomingCallNotification:(NSNotification*)notification;

@end
