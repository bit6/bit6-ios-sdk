//
//  Bit6SDK.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/18/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Bit6Constants.h"
#import "Bit6Conversation.h"
#import "Bit6OutgoingMessage.h"
#import "Bit6Session.h"
#import "Bit6ThumbnailImageView.h"
#import "Bit6AudioPlayerController.h"
#import "Bit6AudioRecorderController.h"
#import "Bit6CurrentLocationController.h"

/*! Bit6 handles the basic interaction between the Bit6 framework and the ApplicationDelegate object */
@interface Bit6 : NSObject

/*! Bit6 startup method. It should be the first call to Bit6 api made.
 * @param apiKey unique key for the current developer.
 */
+ (void) init:(NSString*)apiKey;

@end

#define BIT6_IOS_SDK_VERSION_STRING @"1.0.0"