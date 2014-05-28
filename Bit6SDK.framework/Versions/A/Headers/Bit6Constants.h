//
//  Bit6Constants.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/31/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

typedef void (^Bit6CompletionHandler) (NSDictionary *response, NSError *error);

extern NSString* const Bit6RemoteNotificationReceived;
extern NSString* const Bit6DidRegisterForRemoteNotifications;
extern NSString* const Bit6DidFailToRegisterForRemoteNotifications;

extern NSString* const Bit6MessagesUpdatedNotification;
extern NSString* const Bit6ConversationsUpdatedNotification;

extern NSString* const Bit6TypingDidBeginRtNotification;
extern NSString* const Bit6TypingDidEndRtNotification;
extern NSString* const Bit6TypingAddressKey;

