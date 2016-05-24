//
//  AVRecorderController.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 12/13/13.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Bit6AudioRecorderControllerDelegate;

/*! Bit6AudioRecorderController is used to record an audio file and attach it to a message. */
@interface Bit6AudioRecorderController : NSObject

/*! Unavailable init. Use Bit6.audioRecorder instead.
 @return a new instance of the class.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/*! Tries to start to record an audio file. It can show an <UIAlertView> object as the UI control to cancel or finish the recording.
 @param maxDuration maximum allowed duration (in seconds) of the audio file to be recorded.
 @param delegate the delegate to be notified when the recording has been completed or canceled. For details about the methods that can be implemented by the delegate, see <Bit6AudioRecorderControllerDelegate> Protocol Reference.
 @param defaultPrompt if YES then a default UIAlertView will be shown to handle the recording. If NO then you need to provide a custom UI to handle the recording.
 @param errorHandler used to determine if an error occurs
 */
- (void)startRecordingAudioWithMaxDuration:(NSTimeInterval)maxDuration delegate:(nullable id <Bit6AudioRecorderControllerDelegate>)delegate defaultPrompt:(BOOL)defaultPrompt errorHandler:(nullable void (^)(NSError* _Nullable error))errorHandler;

/*! Gets the length of the current recording - only valid while recording */
@property (nonatomic, readonly) double duration;

/*! Used to know if there's a recording in process. */
@property (nonatomic, readonly) BOOL isRecording;

/*! Cancel a recording without saving the audio file. */
- (void)cancelRecording;

/*! Finish the recording and saves the audio file to cache. */
- (void)stopRecording;

@end

/*! The Bit6AudioRecorderControllerDelegate protocol defines the methods a delegate of a <Bit6AudioRecorderController> object should implement. The methods of this protocol notify the delegate when the recording was either completed or canceled by the user.
 */
@protocol Bit6AudioRecorderControllerDelegate <NSObject>

/*! Called when a user has completed the recording prccess.
 @param b6rc The controller object recording the audio file.
 @param filePath file where the audio was saved.
 */
- (void)doneRecorderController:(nonnull Bit6AudioRecorderController*)b6rc filePath:(nonnull NSString*)filePath;

/*! Called each 0.5 seconds while recording.
 @param b6rc The controller object recording the audio file.
 @param filePath file where the audio is being saved.
 */
- (void)isRecordingWithController:(nonnull Bit6AudioRecorderController*)b6rc filePath:(nonnull NSString*)filePath;

/*! Called when a user has cancelled the recording process.
 @param b6rc The controller object recording the audio file.
 */
- (void)cancelRecorderController:(nonnull Bit6AudioRecorderController*)b6rc;

@end