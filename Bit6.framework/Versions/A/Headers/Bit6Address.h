//
//  Bit6Address.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/02/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NS_STRING_ENUM
#define NS_STRING_ENUM
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NSString* Bit6AddressScheme NS_STRING_ENUM;
extern Bit6AddressScheme const Bit6AddressSchemeGroup;
extern Bit6AddressScheme const Bit6AddressSchemeFacebook;
extern Bit6AddressScheme const Bit6AddressSchemeEmail;
extern Bit6AddressScheme const Bit6AddressSchemeTel;
extern Bit6AddressScheme const Bit6AddressSchemeUser;
extern Bit6AddressScheme const Bit6AddressSchemeUID;
extern Bit6AddressScheme const Bit6AddressSchemeGoogle;
extern Bit6AddressScheme const Bit6AddressSchemeZendesk;

extern NSString* const Bit6ProfilePicturePrefix;

/*! Bit6Address is used to describe an user identity for calling and messaging. */
@interface Bit6Address : NSObject

/*! Unavailable init.
 @return a new instance of the class.
 */
- (instancetype)init NS_UNAVAILABLE;

///---------------------------------------------------------------------------------------
/// @name ￼Initializers
///---------------------------------------------------------------------------------------

/*! Initializes a Bit6Address object
 @param uri URI string to identify the address. An URI address is a two part string composed by a scheme and a value, separated by a colon. Examples `usr:calitb`, mailto:bit6@bit6.com .
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithURI:(NSString*)uri;

/*! Initializes a Bit6Address object using a scheme and a value. The resulting object URI will become scheme:value .
 @param scheme scheme portion of the URI, for example "usr", "tel", "fb", etc
 @param value value portion of the URI.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithScheme:(Bit6AddressScheme)scheme value:(NSString*)value;

/*! Initializes a Bit6Address object using an username. The resulting object URI will become usr:username .
 @param username value portion of the username URI.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithUsername:(NSString*)username;

/*! Initializes a Bit6Address object using an email. The resulting object URI will become mailto:email .
 @param email value portion of the email URI.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithEmail:(NSString*)email;

/*! Initializes a Bit6Address object using an email. The resulting object URI will become tel:phone .
 @param phone a valid phone number. Phone numbers must be in E164 format, prefixed with +. So a US (country code 1) number (555) 123-1234 must be presented as +15551231234.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithPhone:(NSString*)phone;

/*! Initializes a Bit6Address object using a Facebook identifier. The resulting object URI will become fb:facebookId .
 @param facebookId identifier for a facebook user.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (nullable instancetype)addressWithFacebookId:(NSString*)facebookId;

///---------------------------------------------------------------------------------------
/// @name ￼Properties
///---------------------------------------------------------------------------------------

/*! returns the URI representation of the sender. */
@property (nonatomic, readonly, strong) NSString* uri;

/*! returns the sender's scheme. */
@property (nonatomic, readonly) Bit6AddressScheme scheme;

/*! returns the sender's value. */
@property (nonatomic, readonly, strong) NSString* value;

///---------------------------------------------------------------------------------------
/// @name ￼Utilities
///---------------------------------------------------------------------------------------

/*! indicates if the sender refers to a group. */
@property (nonatomic, readonly) BOOL isGroup;

/*! indicates whether the sender supports OFFNET communications. */
@property (nonatomic, readonly) BOOL supportsOffNetCommunications;

/*! Returns a Boolean value that indicates whether a given scheme matches the sender's scheme.
 @param aString A string.
 @return YES if aString matches the URI's sender, otherwise NO.
 */
- (BOOL)hasScheme:(Bit6AddressScheme)aString;

@end

NS_ASSUME_NONNULL_END
