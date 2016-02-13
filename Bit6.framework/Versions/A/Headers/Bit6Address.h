//
//  Bit6Address.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/02/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Bit6Address is used to describe an user identity for calling and messaging. */
@interface Bit6Address : NSObject

///---------------------------------------------------------------------------------------
/// @name ￼Initializers
///---------------------------------------------------------------------------------------

/*! Initializes a Bit6Address object
 @param uri URI string to identify the address. An URI address is a two part string composed by a scheme and a value, separated by a colon. Examples `usr:calitb`, mailto:bit6@bit6.com .
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithURI:(nonnull NSString*)uri;

/*! Initializes a Bit6Address object using a scheme and a value. The resulting object URI will become scheme:value .
 @param scheme scheme portion of the URI, for example "usr", "tel", "fb", etc
 @param value value portion of the URI.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithScheme:(nonnull NSString*)scheme value:(nonnull NSString*)value;

/*! Initializes a Bit6Address object using an username. The resulting object URI will become usr:username .
 @param username value portion of the username URI.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithUsername:(nonnull NSString*)username;

/*! Initializes a Bit6Address object using an email. The resulting object URI will become mailto:email .
 @param email value portion of the email URI.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithEmail:(nonnull NSString*)email;

/*! Initializes a Bit6Address object using an email. The resulting object URI will become tel:phone .
 @param phone a valid phone number. It must include the country code, for example +19543308410.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithPhone:(nonnull NSString*)phone;

/*! Initializes a Bit6Address object using a Facebook identifier. The resulting object URI will become fb:facebookId .
 @param facebookId identifier for a facebook user.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithFacebookId:(nonnull NSString*)facebookId;

///---------------------------------------------------------------------------------------
/// @name ￼Properties
///---------------------------------------------------------------------------------------

/*! A display name for the sender. */
@property (nullable, nonatomic, readonly) NSString* displayName;

/*! returns the URI representation of the sender. */
@property (nonnull, nonatomic, readonly) NSString* uri;

/*! returns the sender's scheme. */
@property (nonnull, nonatomic, readonly) NSString* scheme;

/*! returns the sender's value. */
@property (nonnull, nonatomic, readonly) NSString* value;

///---------------------------------------------------------------------------------------
/// @name ￼Utilities
///---------------------------------------------------------------------------------------

/*! indicates if the sender refers to a group. */
@property (nonatomic, readonly) BOOL isGroup;

/*! Returns a Boolean value that indicates whether a given scheme matches the sender's scheme.
 @param aString A string.
 @return YES if aString matches the URI's sender, otherwise NO.
 */
- (BOOL)hasScheme:(nonnull NSString*)aString;

@end
