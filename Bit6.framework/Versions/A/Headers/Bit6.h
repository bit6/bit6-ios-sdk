//
//  Bit6.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 05/02/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#ifndef _BIT6_H
#define _BIT6_H
#endif

#import <Foundation/Foundation.h>

#import "Bit6Constants.h"
#import "Bit6Conversation.h"
#import "Bit6Group.h"
#import "Bit6Address.h"
#import "Bit6Message.h"
#import "Bit6OutgoingMessage.h"
#import "Bit6Session.h"
#import "Bit6AudioPlayerController.h"
#import "Bit6AudioRecorderController.h"
#import "Bit6CurrentLocationController.h"
#import "Bit6Transfer.h"
#import "Bit6CallController.h"
#import "Bit6CallViewController.h"
#import "Bit6Utils.h"
#import "Bit6PushNotificationCenter.h"
#import "Bit6FileDownloader.h"

#define BIT6_IOS_SDK_VERSION_STRING @"0.9.8"
#define WEBRTC_VERSION_STRING @"M49"

/*! Bit6 handles the basic interaction between the Bit6 framework and the ApplicationDelegate object and offers some generic functionality. */
@interface Bit6 : NSObject

/*! Unavailable init. Use [Bit6 sharedInstance] instead.
 @return a new instance of the class.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/*! Gets the default Bit6 object.
 @return Default Bit6 object.
 */
+ (nonnull Bit6 *)sharedInstance;

///---------------------------------------------------------------------------------------
/// @name ￼Initialization
///---------------------------------------------------------------------------------------

/*! Bit6 startup method.
 @param apiKey unique key for the current developer.
 */
+ (void)startWithApiKey:(nonnull NSString*)apiKey;

/*! Bit6 startup method.
 @param apiKey unique key for the current developer.
 @param endPoint custom server URL
 */
+ (void)startWithApiKey:(nonnull NSString*)apiKey endPoint:(nonnull NSString*)endPoint;

/*! Returns YES if the Bit6 framework has been initialized */
+ (BOOL)started;

///---------------------------------------------------------------------------------------
/// @name ￼Controllers
///---------------------------------------------------------------------------------------

/*! Returns the default Bit6Session object.
 @return the default Bit6Session object.
 */
+ (nonnull Bit6Session*)session;

/*! Gets the default Bit6AudioPlayerController object.
 @return Default Bit6AudioPlayerController object.
 */
+ (nonnull Bit6AudioPlayerController*)audioPlayer;

/*! Gets default Bit6AudioRecorderController object.
 @return Default Bit6AudioRecorderController object.
 */
+ (nonnull Bit6AudioRecorderController*)audioRecorder;

/*! Returns the default Bit6CurrentLocationController object.
 @return the default Bit6CurrentLocationController object.
 */
+ (nonnull Bit6CurrentLocationController*)locationController;

/*! Returns the default Bit6PushNotificationCenter object.
 @return the default Bit6PushNotificationCenter object.
 */
+ (nonnull Bit6PushNotificationCenter*)pushNotification;

///---------------------------------------------------------------------------------------
/// @name ￼Properties
///---------------------------------------------------------------------------------------

/*! Get the current configuration to play video attachments.
 @return true if the video attachments will be downloaded to be played locally. false if the video will be streamed.
 @see +[Bit6 playVideoFromMessage:viewController:]
 @note Deprecated: Please use +[Bit6 downloadVideosBeforePlaying] instead
 */
+ (BOOL)shouldDownloadVideoBeforePlaying __attribute__((deprecated("Please use +[Bit6 downloadVideosBeforePlaying] instead")));

/*! Get the current configuration to download audio attachments automatically.
 @return true if the audio attachments will be downloaded automatically.
 @note Deprecated: Please use +[Bit6 downloadAudioRecordings] instead
 */
+ (BOOL)shouldDownloadAudioRecordings __attribute__((deprecated("Please use +[Bit6 downloadAudioRecordings] instead")));;

/*! Get the current configuration to play video attachments. By default it's set to NO.
 @return true if the video attachments will be downloaded to be played locally. false if the video will be streamed.
 @see +[Bit6 playVideoFromMessage:viewController:]
 */
+ (BOOL)downloadVideosBeforePlaying;

/*! Set the current configuration to play video attachments.
 @param flag true if the video attachments should be downloaded to be played locally. false if the video should be streamed.
 */
+ (void)setDownloadVideosBeforePlaying:(BOOL)flag;

/*! Get the current configuration to download audio attachments automatically. By default it's set to YES.
 @return true if the audio attachments will be downloaded automatically.
 */
+ (BOOL)downloadAudioRecordings;

/*! Set the current configuration to download audio attachments automatically.
 @param flag true if the audio attachments should be downloaded automatically.
 */
+ (void)setDownloadAudioRecordings:(BOOL)flag;

/*! Set the current configuration to load the messages and groups. If set to NO, the messages and groups won't be loaded from the server. By default it's set to YES.
 @param flag true if the messages and groups should be retrieved from the server.
 */
+ (void)setLoadOfMessagesAndGroups:(BOOL)flag;

/*! Enable the logs for Bit6. By default it's set to NO.
 @param flag true if the logs for Bit6 should be enabled.
 */
+ (void)setLoggingEnabled:(BOOL)flag;

/*! Set the <Bit6CallViewController> subclass to be used during a call. This method should be called before [Bit6 startWithApiKey:].
 @param value UI class to be used during a call.
 */
+ (void)setInCallClass:(nonnull Class)value;

/*! Returns the timestamp matching the last message with status Bit6MessageStatus_Delivered. */
@property (nonatomic, readonly) double deliveredUntil;

/*! Returns the timestamp matching the last message with status Bit6MessageStatus_Read. */
@property (nonatomic, readonly) double readUntil;

///---------------------------------------------------------------------------------------
/// @name ￼Cache
///---------------------------------------------------------------------------------------

/*! Get the size of the /Cache/bit6 directory.
 @return cache size in bytes.
 */
+ (NSUInteger)cacheSize;

/*! Get the number of files inside the /Cache/bit6 directory.
 @return number of files in cache.
 */
+ (NSUInteger)numberOfItemsInCache;

/*! Delete all the files inside the /Cache/bit6 directory.
 @return number of files deleted.
 */
+ (NSUInteger)clearCache;

/*! Delete the files inside the /Cache/bit6 directory that matches the specified prefix.
 @param prefix prefix of the files to delete
 @return number of files deleted.
 */
+ (NSUInteger)clearCacheWithPrefix:(nonnull NSString*)prefix;

///---------------------------------------------------------------------------------------
/// @name ￼Working with Groups
///---------------------------------------------------------------------------------------

/*! Get all the existing groups.
 @return the existing <Bit6Group> objects as a NSArray.
 */
+ (nullable NSArray<Bit6Group*>*)groups;

///---------------------------------------------------------------------------------------
/// @name ￼Working with Conversations
///---------------------------------------------------------------------------------------

/*! Set the comparator block that will be used to sort the conversations.
 @param cmptr new sorting comparator..
 */
+ (void)setConversationSortingComparator:(nonnull NSComparator)cmptr;

/*! Get all the existing conversations.
 @return the existing <Bit6Conversation> objects as a NSArray, or null if no session has been initiated.
 */
+ (nullable NSArray<Bit6Conversation*>*)conversations;

/*! Adds a conversation to the system.
 @param conversation a <Bit6Conversation> object to be added.
 @return YES if the conversation was added
 */
+ (BOOL)addConversation:(nonnull Bit6Conversation*)conversation;

/*! Delete a conversation from the system. All the messages inside the conversation are deleted too.
 @param conversation <Bit6Conversation> object to be deleted
 @param completion block to be called when the operation is completed.
 */
+ (void)deleteConversation:(nonnull Bit6Conversation*)conversation completion:(nullable Bit6CompletionHandler)completion;

/*! Deletes a message from the system.
 @param message <Bit6Message> object to be deleted
 @param completion block to be called when the operation is completed.
 */
+ (void)deleteMessage:(nonnull Bit6Message*)message completion:(nullable Bit6CompletionHandler)completion;

/*! Deletes all messages from the system.
 @param completion block to be called when the operation is completed.
 @note Use at your own risk.
 */
+ (void)deleteMessagesWithCompletion:(nullable Bit6CompletionHandler)completion;

/*! Gets the number of unread messages for all existing conversations.
 @discussion This is done by adding the values of <-[Bit6Conversation badge]> for all existing conversations
 @return The number of unread messages for all existing conversations.
 */
+ (nonnull NSNumber*)totalBadge;

/*! Set the current conversation for the application. The current conversation will have its <[Bit6Conversation badge]> set to 0 and it won't consider new messages to increment this value. Set this property to nil to remove the current conversation.
 @param conversation conversation to become the current conversation.
 */
+ (void)setCurrentConversation:(nullable Bit6Conversation*)conversation;

/*! Gets the current conversation for the application. */
+ (nullable Bit6Conversation*)currentConversation;

///---------------------------------------------------------------------------------------
/// @name ￼Getting Messages
///---------------------------------------------------------------------------------------

/*! Get the <Bit6Message> objects in the system as a NSArray.
 @param offset initial index to look for messages
 @param length number of messages to get
 @param asc order in which the messages will be returned
 @return <Bit6Message> objects as a NSArray.
 @see +[Bit6 messagesInConversation:offset:length:asc:]
 */
+ (nonnull NSArray<Bit6Message*>*)messagesWithOffset:(NSInteger)offset length:(NSInteger)length asc:(BOOL)asc;

/*! Get the <Bit6Message> objects in the conversation as a NSArray.
 @discussion Let's assume we have these messages: [1, 2, 3, 4, 5] (smaller numbers - older messages)

    [Bit6 messagesInConversation:myConversation offset:1 length:2 asc:YES]; // returns [2,3]
    [Bit6 messagesInConversation:myConversation offset:1 length:2 asc:NO]; // returns [3,2]
    [Bit6 messagesInConversation:myConversation offset:-2 length:2 asc:NO]; // returns [5,4]
    [Bit6 messagesInConversation:myConversation offset:-2 length:2 asc:YES]; // returns [4,5]
    [Bit6 messagesInConversation:myConversation offset:0 length:NSIntegerMax asc:YES]; // returns all the messages [1,2,3,4,5]
    [Bit6 messagesInConversation:myConversation offset:0 length:NSIntegerMax asc:NO]; // returns all the messages [5,4,3,2,1]
    [Bit6 messagesInConversation:myConversation offset:-3 length:3 asc:NO]; // returns [5,4,3]
    [Bit6 messagesInConversation:myConversation offset:-6 length:3 asc:NO]; // returns [2,1]
 
 @param conversation the <Bit6Conversation> object to get the messages from
 @param offset initial index to look for messages
 @param length number of messages to get
 @param asc order in which the messages will be returned
 @return <Bit6Message> objects as a NSArray.
 */
+ (nonnull NSArray<Bit6Message*>*)messagesInConversation:(nonnull Bit6Conversation*)conversation offset:(NSInteger)offset length:(NSInteger)length asc:(BOOL)asc;

/*! Get the <Bit6Message> objects with attachment as a NSArray.
 @param messages array of <Bit6Message> objects where to do the search
 @return <Bit6Message> objects with attachment as a NSArray.
 */
+ (nonnull NSArray<Bit6Message*>*)messagesWithAttachmentInMessages:(nonnull NSArray<Bit6Message*>*)messages;

/*! Get the <Bit6Message> objects with attachment as a NSArray.
 @param conversation conversation where to do the search
 @param asc order in which the messages will be returned
 @return <Bit6Message> objects with attachment as a NSArray.
 */
+ (nonnull NSArray<Bit6Message*>*)messagesWithAttachmentInConversation:(nonnull Bit6Conversation*)conversation asc:(BOOL)asc;

///---------------------------------------------------------------------------------------
/// @name ￼Calls
///---------------------------------------------------------------------------------------

/*! The in-call view controller being used during the current call.
 @return <Bit6CallViewController> object referencing the current in-call view controller.
 */
+ (nullable Bit6CallViewController*)callViewController;

/*! List of <Bit6CallController> objects in the current call.
 @return an NSArray of <Bit6CallController> objects in the current call.
 */
+ (nonnull NSArray<Bit6CallController*>*)callControllers;

/*! Starts a VoIP call.
 @param identity address of the user to call
 @param streams An integer bit mask that determines the local media that will be sent.
 @return NO if the call can't be started
 */
+ (BOOL)startCallTo:(nonnull Bit6Address*)identity streams:(Bit6CallStreams)streams;

/*! Starts a PSTN call
 @param phoneNumber phoneNumber to call. Phone numbers must be in E164 format, prefixed with +. So a US (country code 1) number (555) 123-1234 must be presented as +15551231234.
 @return NO if the call can't be started
 */
+ (BOOL)startPhoneCallTo:(nonnull NSString*)phoneNumber;

/*! Creates a view controller to use during a call, or reuse an existing one.
 @discussion The class for the returned viewcontroller can be customize by adding the class name with the key 'in_call_class_name' in the Bit6 dictionary in the target info.plist. If set then the <+(nonnull Bit6CallViewController*)createViewController> method for that class will be called to create the viewcontroller.
 @param callController call for which the viewcontroller will be generated.
 @return viewcontroller to use during a call.
 */
+ (nullable Bit6CallViewController*)createViewControllerForCall:(nonnull Bit6CallController*)callController;

///---------------------------------------------------------------------------------------
/// @name ￼Actions
///---------------------------------------------------------------------------------------

/*! Plays the attached video included in a <Bit6Message> object using the MPMoviePlayerViewController class.
 @param msg A <Bit6Message> object with a video attached. A message has a video attached if Bit6Message.type == Bit6MessageType_Attachments and Bit6Message.attachFileType == Bit6MessageFileType_VideoMP4.
 @param vc viewcontroller from which to present the MPMoviePlayerViewController control to play the video
 @see +[Bit6 downloadVideosBeforePlaying]
 */
+ (void)playVideoFromMessage:(nonnull Bit6Message*)msg viewController:(nonnull UIViewController*)vc;

/*! Convenience method to open the location included in a <Bit6Message> object in the Apple Maps app.
 @param msg A <Bit6Message> object with a location attached. A message has a location attached if Bit6Message.type == Bit6MessageType_Location. */
+ (void)openLocationOnMapsFromMessage:(nonnull Bit6Message*)msg;

/*! Used to notify when the user starts typing. 
 @param address address where the notification will be sent
 */
+ (void)typingBeginToAddress:(nonnull Bit6Address*)address;

/*! Used to send a notification to another user. To receive the notification in the other end you can hear to the Bit6CustomRtNotification notifications.
 @param address The <Bit6Address> object to send the message
 @param type type of the notification to send
 @param data data to send in the notification. It has to be able to be converted to JSON data (check by using +[NSJSONSerialization 
 */
+ (void)sendNotificationToAddress:(nonnull Bit6Address *)address type:(nonnull NSString *)type data:(nonnull NSDictionary<NSString*,id>*)data;

@end
