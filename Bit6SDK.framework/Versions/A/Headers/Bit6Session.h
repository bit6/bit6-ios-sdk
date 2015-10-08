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

/*! A Bit6Session object contains the session information about the current connection to the Bit6 platform. It allows the user to sign up for a new account with the app, login into an existing account or logout. */
@interface Bit6Session : NSObject

/*! Checks if the user is authenticated with the Bit6 platform and the session has been established.*/
@property (nonatomic) BOOL authenticated;

/*! Web Socket connection status. */
@property (nonatomic, readonly) Bit6RTStatus rtConnectionStatus;

/*! Used to retrieve values from the user profile when using a <Bit6SessionProvider> to initiate a session
 @param key identifier of the value to get
 @return value for the specified key
 */
- (id)valueForProfileKey:(NSString*)key;

/*! Creates an account with an <Bit6Address> object and initiates the session.
 @param userIdentity A <Bit6Address> object that represents the local user.
 @param pass User's password
 @param completion Block to call after the operation has been completed. The "error" value can be use to know if the account was created.
 */
- (void)signUpWithUserIdentity:(Bit6Address*)userIdentity password:(NSString*)pass completionHandler:(Bit6CompletionHandler)completion;

/*! Signs into an existing account
 @param userIdentity <Bit6Address> object that represents the local user
 @param pass User's password
 @param completion Block to call after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)loginWithUserIdentity:(Bit6Address*)userIdentity password:(NSString*)pass completionHandler:(Bit6CompletionHandler)completion;

/*! Signs in using an anonymous account.
 @param completion Block to call after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)anonymousWithCompletionHandler:(Bit6CompletionHandler)completion;

/*! Ends the current session.
 @param completion Block to be executed after the operation has been completed.
 */
- (void)logoutWithCompletionHandler:(Bit6CompletionHandler)completion;

/*! Change the password for the current user
 @param oldPassword the user's old password
 @param newPassword the new password for the user
 @param completion Block to call after the operation has been completed.
 */
- (void)changePassword:(NSString*)oldPassword newPassword:(NSString*)newPassword completionHandler:(Bit6CompletionHandler)completion;

/*! Current user identity as a <Bit6Address> object */
@property (nonatomic, readonly) Bit6Address *userIdentity;

/*! Public profile of the current user. */
- (NSDictionary*)publicProfile;

/*! Used to set the public profile of the current user. 
 @param publicProfile New public profile for the current user.
 @param completion Block to call after the operation has been completed.
 */
- (void)setPublicProfile:(NSDictionary*)publicProfile completion:(Bit6CompletionHandler)completion;

/*! Private profile of the current user. */
- (NSDictionary*)privateData;

/*! Used to set the private profile of the current user.
 @param privateData New private profile for the current user.
 @param completion Block to call after the operation has been completed.
 */
- (void)setPrivateData:(NSDictionary*)privateData completion:(Bit6CompletionHandler)completion;

/*! Get the OAuth configurations available
 @param completion Block to be executed after the operation has been completed.
 */
- (void)getAuthInfoCompletionHandler:(Bit6CompletionHandler)completion;

/*! Signs in using an OAuth provider
 @param provider the provider as a value of the <Bit6SessionProvider> enumeration.
 @param params additional params required to perform the sign in
 @param completion Block to be executed after the operation has been completed. The "error" value can be use to know if the session was initiated.
 */
- (void)oauthForProvider:(NSString*)provider params:(NSDictionary*)params completion:(Bit6CompletionHandler)completion;

@end
