//
//  Bit6.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 05/02/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Conversation.h"
#import "Bit6Message.h"
#import "Bit6Constants.h"
#import "Bit6CallController.h"
#import "Bit6Session.h"
#import "Bit6AudioPlayerController.h"
#import "Bit6AudioRecorderController.h"
#import "Bit6CurrentLocationController.h"
#import "Bit6IncomingCallNotificationBanner.h"

/*! Bit6 handles the basic interaction between the Bit6 framework and the ApplicationDelegate object */
@interface Bit6 : NSObject

///---------------------------------------------------------------------------------------
/// @name ￼Initialization
///---------------------------------------------------------------------------------------

/*! Bit6 startup method. It should be the first call to Bit6 api made.
 @param apiKey unique key for the current developer.
 @param pushNotificationMode One of the values in <Bit6PushNotificationMode> enumeration.
 @param launchOptions used to send the launchOptions from [UIApplicationDelegate application:didFinishLaunchingWithOptions:] to Bit6
 */
+ (void) startWithApiKey:(NSString*)apiKey pushNotificationMode:(Bit6PushNotificationMode)pushNotificationMode launchingWithOptions:(NSDictionary *)launchOptions;

///---------------------------------------------------------------------------------------
/// @name ￼Controllers
///---------------------------------------------------------------------------------------

/*! Returns the default Bit6Session object.
 @return the default Bit6Session object.
 */
+ (Bit6Session*) session;

/*! Gets the default Bit6AudioPlayerController object.
 @return Default Bit6AudioPlayerController object.
 */
+ (Bit6AudioPlayerController*) audioPlayer;

/*! Gets default Bit6AudioRecorderController object.
 @return Default Bit6AudioRecorderController object.
 */
+ (Bit6AudioRecorderController*) audioRecorder;

/*! Returns the default Bit6CurrentLocationController object.
 @return the default Bit6CurrentLocationController object.
 */
+ (Bit6CurrentLocationController*) locationController;

/*! Returns the default Bit6IncomingCallNotificationBanner object.
 @return the default Bit6IncomingCallNotificationBanner object.
 */
+ (Bit6IncomingCallNotificationBanner*) incomingCallNotificationBanner;

///---------------------------------------------------------------------------------------
/// @name ￼Properties
///---------------------------------------------------------------------------------------

/*! Configure the video attachments playing mode.
 @param shouldDownloadVideoBeforePlaying if true the video attachments will be downloaded to be played locally. If false, the video will be streamed.
 */
+ (void) setShouldDownloadVideoBeforePlaying:(BOOL)shouldDownloadVideoBeforePlaying;

/*! Obtains the current configuration to play video attachments.
 @return true if the video attachments will be downloaded to be played locally. false if the video will be streamed.
 */
+ (BOOL) shouldDownloadVideoBeforePlaying;

///---------------------------------------------------------------------------------------
/// @name ￼Working with Groups
///---------------------------------------------------------------------------------------

/*! Get all the existing groups.
 @return the existing <Bit6Group> objects as a NSArray.
 */
+ (NSArray*) groups;

///---------------------------------------------------------------------------------------
/// @name ￼Working with Conversations
///---------------------------------------------------------------------------------------

/*! Get all the existing conversations.
 @return the existing <Bit6Conversation> objects as a NSArray.
 */
+ (NSArray*) conversations;

/*! Adds a conversation to the system.
 @param conversation a <Bit6Conversation> object to be added.
 @return YES if the conversation was added
 */
+ (BOOL) addConversation:(Bit6Conversation*)conversation;

/*! Delete a conversation from the system. All the messages inside the conversation are deleted too.
 @param conversation <Bit6Conversation> object to be deleted
 @param completion block to be called when the operation is completed.
 */
+ (void) deleteConversation:(Bit6Conversation*)conversation completion:(Bit6CompletionHandler)completion;

/*! Deletes a message from the system.
 @param message <Bit6Message> object to be deleted
 @param completion block to be called when the operation is completed.
 */
+ (void) deleteMessage:(Bit6Message*)message completion:(Bit6CompletionHandler)completion;

/*! Gets the number of unread messages for all existing conversations.
 @discussion This is done by adding the values of <-[Bit6Conversation badge]> for all existing conversations
 @return The number of unread messages for all existing conversations.
 */
+ (NSNumber *) totalBadge;

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
+ (NSArray*) messagesWithOffset:(NSInteger)offset length:(NSInteger)length asc:(BOOL)asc;

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
+ (NSArray*) messagesInConversation:(Bit6Conversation*)conversation offset:(NSInteger)offset length:(NSInteger)length asc:(BOOL)asc;

/*! Get the <Bit6Message> objects with attachment as a NSArray.
 @param messages array of <Bit6Message> objects where to do the search
 @return <Bit6Message> objects with attachment as a NSArray.
 */
+ (NSArray*) messagesWithAttachmentInMessages:(NSArray*)messages;

/*! Get the <Bit6Message> objects with attachment as a NSArray.
 @param conversation conversation where to do the search
 @param asc order in which the messages will be returned
 @return <Bit6Message> objects with attachment as a NSArray.
 */
+ (NSArray*) messagesWithAttachmentInConversation:(Bit6Conversation*)conversation asc:(BOOL)asc;

///---------------------------------------------------------------------------------------
/// @name ￼Calls
///---------------------------------------------------------------------------------------

/*! Get the <Bit6CallController> object of the current call.
 @return <Bit6CallController> object of the current call
 */
+ (Bit6CallController*) currentCallController;

/*! Creates a <Bit6CallController> to reference a VoIP call
 @param address address of the user to call
 @param hasVideo indicate if the call will include a video stream
 @return <Bit6CallController> object to handle the call
 */
+ (Bit6CallController*) startCallToAddress:(Bit6Address*)address hasVideo:(BOOL)hasVideo;

/*! Creates a <Bit6CallController> to reference a PSTN call
 @param phoneNumber phoneNumber to call. Phone numbers must be in E164 format, prefixed with +. So a US (country code 1) number (555) 123-1234 must be presented as +15551231234.
 @return <Bit6CallController> object to handle the call
 */
+ (Bit6CallController*) startCallToPhoneNumber:(NSString*)phoneNumber;

/*! Creates a <Bit6CallController> to reference a answer call
 @param notification <Bit6IncomingCallNotification> notification of incoming call
 @return <Bit6CallController> object to handle the call
 */
+ (Bit6CallController*) callControllerFromIncomingCallNotification:(NSNotification*)notification;

/*! Shows the UI associated to a call controller in a new UIWindow using a "slide up from the bottom of the screen" transition.
 @param callController call controller object to present.
 */
+ (void) presentCallController:(Bit6CallController*)callController;

/*! Dismiss the UI associated to a call controller using a "slide down from the top of the screen" transition. The UI must have been presented using <presentCallController:>.
 @param callController call controller object to dismiss.
 */
+ (void) dismissCallController:(Bit6CallController*)callController;

///---------------------------------------------------------------------------------------
/// @name ￼Actions
///---------------------------------------------------------------------------------------

/*! Plays the attached video included in a <Bit6Message> object using the MPMoviePlayerViewController class.
 @param msg A <Bit6Message> object with a video attached. A message has a video attached if Bit6Message.type == Bit6MessageType_Attachments and Bit6Message.attachFileType == Bit6MessageFileType_VideoMP4.
 @param vc viewcontroller from which to present the MPMoviePlayerViewController control to play the video
 */
+ (void) playVideoFromMessage:(Bit6Message*)msg viewController:(UIViewController*)vc;

/*! Convenience method to open the location included in a <Bit6Message> object in the Apple Maps app.
 @param msg A <Bit6Message> object with a location attached. A message has a location attached if Bit6Message.type == Bit6MessageType_Location. */
+ (void) openLocationOnMapsFromMessage:(Bit6Message*)msg;

/*! Used to notify when the user starts typing. 
 @param address address where the notification will be sent
 */
+ (void) typingBeginToAddress:(Bit6Address*)address;

/*! Used to send a notification to another user. To receive the notification in the other end you can hear to the Bit6CustomRtNotification notifications.
 @param address The <Bit6Address> object to send the message
 @param type type of the notification to send
 @param data data to send in the notification
 */
+ (void) sendNotificationToAddress:(Bit6Address *)address type:(NSString *)type data:(NSDictionary *)data;

@end
