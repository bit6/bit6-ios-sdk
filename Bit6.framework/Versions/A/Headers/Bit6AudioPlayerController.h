//
//  Bit6AudioPlayerController.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/08/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*! Audio player allows to play an audio file. */
@interface Bit6AudioPlayerController : NSObject

/*! Unavailable init. Use Bit6.audioPlayer instead.
 @return a new instance of the class.
 */
- (instancetype)init NS_UNAVAILABLE;

/*! Starts playing an audio file. You can listen to the `Bit6AudioPlayingNotification` to update your UI while playing an audio file.
 @param filePath Path to the audio file to play.
 */
- (void)startPlayingAudioFileAtPath:(NSString*)filePath;

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

NS_ASSUME_NONNULL_END
