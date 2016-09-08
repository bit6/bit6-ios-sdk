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

/*! Request access to the Camera.
 @param successBlock block to be called if the request access prompt was shown and access has been granted.
 @param deniedAccessBlock block to be called if access was denied.
 @return YES if the access is enabled. Returns NO is access is denied or undetermined.
 */
+ (BOOL)requestAccessToCameraWithSuccessBlock:(nullable void (^)())successBlock deniedAccessBlock:(nullable void (^)())deniedAccessBlock;

/*! Request access to the Microphone.
 @param successBlock block to be called if the request access prompt was shown and access has been granted.
 @param deniedAccessBlock block to be called if access was denied.
 @return YES if the access is enabled. Returns NO is access is denied or undetermined.
 */
+ (BOOL)requestAccessToMicrophoneWithSuccessBlock:(nullable void (^)())successBlock deniedAccessBlock:(nullable void (^)())deniedAccessBlock;

/*! Request access to the Photo Library.
 @param successBlock block to be called if the request access prompt was shown and access has been granted.
 @param deniedAccessBlock block to be called if access was denied.
 @return YES if the access is enabled. Returns NO is access is denied or undetermined.
 */
+ (BOOL)requestAccessToPhotosWithSuccessBlock:(nullable void (^)())successBlock deniedAccessBlock:(nullable void (^)())deniedAccessBlock;

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
 @param	destinationRect		The CGRect you wish to fill.
 */
CGRect Bit6MakeRectWithAspectRatioToFillRect(CGSize aspectRatio, CGRect destinationRect);

