//
//  Bit6AudioPlayerController.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/08/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Message.h"

/*! Audio player allows to play an audio file attached to a message. */
@interface Bit6AudioPlayerController : NSObject

/*! Starts playing the audio file attached to a message. You can listen to the `Bit6AudioPlayingNotification` to update your UI while playing an audio file.
 @param msg A <Bit6Message> object with the audio attachment to play.
 @param errorHandler block to call if an error occurs
 */
- (void) startPlayingAudioFileInMessage:(Bit6Message*)msg errorHandler:(void (^)(NSError *error))errorHandler;

/*! Used to know if there's an audio file is playing */
@property (nonatomic, readonly) BOOL isPlayingAudioFile;

/*! Stop the audio file playing at the time */
- (void) stopPlayingAudioFile;

/*! Gets the audio file playing current time. */
@property (nonatomic, readonly) double currentTime;

/*! Gets the length of the audio file playing. */
@property (nonatomic, readonly) double duration;

/*! Gets the current <Bit6Message> object being played.
 @return <Bit6Message> object being played. */
@property (nonatomic, strong, readonly) Bit6Message *messagePlaying;

@end
