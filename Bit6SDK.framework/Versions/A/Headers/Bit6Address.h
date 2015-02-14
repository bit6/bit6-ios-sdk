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
    Bit6AddressKind_FACEBOOK
};

/*! Bit6Address is used to describe a user identity or a destination for calling and messaging. It consists of a type (<Bit6AddressKind>) and a value. */
@interface Bit6Address : NSObject

/*! Initializes a Bit6Address object
 @param kind Destination kind.
 @param value Destination value.
 @return a Bit6Address object if succesful or nil if failed.
 */
+ (instancetype)addressWithKind:(Bit6AddressKind)kind value:(NSString*)value;

/*! A display name for this <Bit6Address> object. */
@property (nonatomic, readonly) NSString *displayName;

/*! returns the kind of BitAddress. 
 @note See <Bit6AddressKind> enumeration
*/
@property (nonatomic, readonly) NSNumber *kind;

/*! returns the value of BitAddress.
 */
@property (nonatomic, readonly) NSString *value;

@end
