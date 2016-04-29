//
//  Bit6Utils.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*! Bit6 utility class. */
@interface Bit6Utils : NSObject

/*! Request access to the Camera. On iOS7 and earlier it always succeeds.
 @param successBlock block to be called if camera access has been granted
 @param failedBlock block to be called if camera access is not granted
 */
+ (void)requestAccessToCameraWithSuccessBlock:(nullable void (^)())successBlock failedBlock:(nullable void (^)())failedBlock;

/*! Request access to the Microphone. On iOS6 it always succeeds.
 @param successBlock block to be called if microphone access has been granted
 @param failedBlock block to be called if microphone access is not granted
 */
+ (void)requestAccessToMicrophoneWithSuccessBlock:(nullable void (^)())successBlock failedBlock:(nullable void (^)())failedBlock;

/*! Convenient method to convert seconds into a clock format NSString. For example 75s will be converted to 01:15
 @param seconds number of seconds to convert
 @return seconds in a clock format. Returns nil if the isnan(seconds).
 */
+ (nullable NSString*)clockFormatForSeconds:(double)seconds;

/*! Convenient method to retrieve the duration of an audio file.
 @param filePath path to the audio file.
 @return duration in seconds of the audio file.
 */
+ (double)audioDurationForFileAtPath:(nonnull NSString*)filePath;

@end

/*!
 @function					Bit6MakeRectWithAspectRatioToFillRect
 @abstract					Returns a scaled CGRect that maintains the aspect ratio specified by a CGSize and filling a destination CGRect.
 @discussion				This is useful when attempting to fill the bounds of a <Bit6CallViewController> by keeping the aspect ratio of the video feed. For example:
                            remoteVideoView.frame = Bit6MakeRectWithAspectRatioToFillRect(remoteVideoAspectRatio,self.view.bounds);
 @note                      Similar to AVMakeRectWithAspectRatioInsideRect in <AVFoundation/AVUtilities.h>
 @param aspectRatio			The width & height ratio, or aspect, you wish to maintain.
 @param	boundingRect		The CGRect you wish to fill.
 */
CGRect Bit6MakeRectWithAspectRatioToFillRect(CGSize aspectRatio, CGRect destinationRect);

