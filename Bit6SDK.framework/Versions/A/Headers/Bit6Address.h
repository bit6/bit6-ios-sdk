//
//  Bit6Address.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 04/02/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Bit6Address kind */
typedef NS_ENUM(NSInteger, Bit6AddressKind) {
    /*! The Bit6Address refers to a phone number */
    Bit6AddressKind_PHONE,
    /*! The Bit6Address refers to an username */
    Bit6AddressKind_USERNAME,
    /*! The Bit6Address refers to an email account */
    Bit6AddressKind_EMAIL,
    /*! The Bit6Address refers to a Facebook account */
    Bit6AddressKind_FACEBOOK,
    /*! The Bit6Address refers to a Google account */
    Bit6AddressKind_GOOGLE,
    /*! The Bit6Address refers to an anonymous session */
    Bit6AddressKind_UID,
    /*! The Bit6Address refers to a group */
    Bit6AddressKind_GROUP
};

/*! Bit6Address is used to describe a user identity or a destination for calling and messaging. It consists of a type (<Bit6AddressKind>) and a value. */
@interface Bit6Address : NSObject

/*! Initializes a Bit6Address object
 @param kind Destination kind.
 @param value Destination value.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (instancetype)addressWithKind:(Bit6AddressKind)kind value:(NSString*)value;

/*! Initializes a Bit6Address object
 @param uri URI string to identify the address
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (instancetype)addressWithURI:(NSString*)uri;

/*! A display name for the sender. */
@property (nonatomic, readonly) NSString *displayName;

/*! returns the kind of sender.
 @note See <Bit6AddressKind> enumeration
*/
@property (nonatomic, readonly) NSNumber *kind;

/*! returns the string representation of the <Bit6Address> object.
 */
@property (nonatomic, readonly) NSString *uri;

/*! Check the <Bit6AddressKind> of the sender
 @param kind <Bit6AddressKind> to compare with the sender
 @return YES if the sender match the <Bit6AddressKind> in the param.
 */
- (BOOL) isKind:(Bit6AddressKind)kind;

/*! returns the value of BitAddress. */
@property (nonatomic, readonly) NSString *value;

@end
