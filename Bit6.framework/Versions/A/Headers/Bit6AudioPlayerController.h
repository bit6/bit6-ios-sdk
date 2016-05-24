//
//  Bit6AudioPlayerController.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/08/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Message.h"

/*! Audio player allows to play an audio file. */
@interface Bit6AudioPlayerController : NSObject

/*! Unavailable init. Use Bit6.audioPlayer instead.
 @return a new instance of the class.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/*! Starts playing an audio file. You can listen to the `Bit6AudioPlayingNotification` to update your UI while playing an audio file.
 @param filePath Path to the audio file to play.
 @param errorHandler block to call if an error occurs
 */
- (void)startPlayingAudioFileAtPath:(nonnull NSString*)filePath errorHandler:(nullable void (^)(NSError* _Nonnull error))errorHandler;

/*! Stop the audio file playing at the time */
- (void)stopPlayingAudioFile;

/*! Gets the audio file playing current time. */
- (double)currentTime;

/*! Gets the length of the audio file playing. */
- (double)duration;

/*! Gets the path to the current audio file being played.
 @return path to the current audio file being played. */
- (nullable NSString*)filePathPlaying;

@end
