//
//  Bit6Session.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 03/20/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bit6Address.h"
#import "Bit6Constants.h"

NS_ASSUME_NONNULL_BEGIN

/*! A Bit6Session object contains the session information about the current connection to the Bit6 platform. It allows the user to sign up for a new account with the app, login into an existing account or logout. */
@interface Bit6Session : NSObject

/*! Unavailable init. Use Bit6.session instead.
 @return a new instance of the class.
 */
- (instancetype)init NS_UNAVAILABLE;

///---------------------------------------------------------------------------------------
/// @name ￼Start/Destroy a session
///---------------------------------------------------------------------------------------

/*! Creates an account and initiates the session.
@param userIdentity A <Bit6Address> object that represents the local user.
@param pass User's password
@param completion Block to call after the operation has been completed. The "error" value can be use to know if the account was created.
*/
- (void)signUpWithUserIdentity:(Bit6Address*)userIdentity password:(NSString*)pass completionHandler:(nullable Bit6CompletionHandler)completion;

/*! Signs into an existing account.
 @param userIdentity <Bit6Address> object that represents the local user
 @param pass User's password
 @param completion Block to call after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)loginWithUserIdentity:(Bit6Address*)userIdentity password:(NSString*)pass completionHandler:(nullable Bit6CompletionHandler)completion;

/*! Signs in using an anonymous account.
 @param completion Block to call after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)anonymousWithCompletionHandler:(nullable Bit6CompletionHandler)completion;

/*! Get the OAuth configurations available.
 @param completion Block to be executed after the operation has been completed.
 */
- (void)getAuthInfoCompletionHandler:(nullable Bit6CompletionHandler)completion;

/*! Signs in using an OAuth provider
 @param provider the provider to use.
 @param params additional params required to perform the sign in. If provided it has to be able to be converted to JSON data (check by using +[NSJSONSerialization isValidJSONObject:])
 @param completion Block to be executed after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)oauthForProvider:(NSString*)provider params:(NSDictionary<NSString*,id>*)params completion:(nullable Bit6CompletionHandler)completion;

/*! Signs in using a token from an external Service.
 @param token token to be used to authenticate the user
 @param completion Block to call after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)authWithExternalToken:(NSString*)token completionHandler:(nullable Bit6CompletionHandler)completion;

/*! Ends the current session.
 @param completion Block to be executed after the operation has been completed.
 */
- (void)logoutWithCompletionHandler:(nullable Bit6CompletionHandler)completion;

///---------------------------------------------------------------------------------------
/// @name Identities
///---------------------------------------------------------------------------------------

/*! Active user identity as a <Bit6Address> object. It can be nil if a session has not been created. */
@property (nullable, nonatomic, strong) Bit6Address* activeIdentity;

/*! Display name to use for the active user. It can be nil if a session has not been created. */
@property (nullable, nonatomic, strong) NSString* activeDisplayName;

/*! List of user identities for the current session. */
@property (nonatomic, readonly) NSArray<Bit6Address*>* identities;

/*! Convenience method to find if an <Bit6Address> identity belongs to the current user. This is done by performing a loop through <[Bit6Session identities]> to try to find the identity.
 @param address identity to search
 @return YES if the address belongs to the current user.
 @see -[Bit6Session identities]
 */
- (BOOL)isMyIdentity:(Bit6Address*)address;

///---------------------------------------------------------------------------------------
/// @name Public/Private Profiles
///---------------------------------------------------------------------------------------

/*! Public profile of the current user. */
- (nullable NSDictionary<NSString*,id>*)publicProfile;

/*! Used to set the public profile of the current user.
 @param publicProfile New public profile for the current user. If provided it has to be able to be converted to JSON data (check by using +[NSJSONSerialization isValidJSONObject:])
 @param completion Block to call after the operation has been completed.
 */
- (void)setPublicProfile:(NSDictionary<NSString*,id>*)publicProfile completion:(nullable Bit6CompletionHandler)completion;

/*! Private profile of the current user. */
- (nullable NSDictionary<NSString*,id>*)privateData;

/*! Used to set the private profile of the current user.
 @param privateData New private profile for the current user. If provided it has to be able to be converted to JSON data (check by using +[NSJSONSerialization isValidJSONObject:])
 @param completion Block to call after the operation has been completed.
 */
- (void)setPrivateData:(NSDictionary<NSString*,id>*)privateData completion:(nullable Bit6CompletionHandler)completion;

///---------------------------------------------------------------------------------------
/// @name Properties
///---------------------------------------------------------------------------------------

/*! Checks if the user is authenticated with the Bit6 platform and the session has been established.*/
@property (nonatomic) BOOL authenticated;

/*! Web Socket connection status. */
@property (nonatomic, readonly) Bit6WebSocketReadyState rtConnectionStatus;

/*! List of device identifiers for the active user. */
@property (nullable, nonatomic, readonly, strong) NSArray<NSString*>* devices;

/*! Unique identifier for this device for the active user. */
@property (nullable, nonatomic, readonly, strong) NSString *currentDevice;

///---------------------------------------------------------------------------------------
/// @name Password
///---------------------------------------------------------------------------------------

/*! Change the password for the current user
 @param oldPassword the user's old password
 @param newPassword the new password for the user
 @param completion Block to call after the operation has been completed.
 */
- (void)changePassword:(NSString*)oldPassword newPassword:(NSString*)newPassword completionHandler:(nullable Bit6CompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
