//
//  Bit6Utils.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Bit6 utility class. */
@interface Bit6Utils : NSObject

/*! Request access to the Camera. On iOS7 and earlier it always succeeds.
 @param successBlock block to be called if camera access has been granted
 @param failedBlock block to be called if camera access is not granted
 */
+ (void) requestAccessToCameraWithSuccessBlock:(void (^)())successBlock failedBlock:(void (^)())failedBlock;

/*! Request access to the Microphone. On iOS6 it always succeeds.
 @param successBlock block to be called if microphone access has been granted
 @param failedBlock block to be called if microphone access is not granted
 */
+ (void) requestAccessToMicrophoneWithSuccessBlock:(void (^)())successBlock failedBlock:(void (^)())failedBlock;

/*! Convenient method to convert seconds into a clock format NSString. For example 75s will be converted to 01:15
 @param seconds number of seconds to convert
 @return seconds in a clock format.
 */
+ (NSString*)clockFormatForSeconds:(double)seconds;

@end
