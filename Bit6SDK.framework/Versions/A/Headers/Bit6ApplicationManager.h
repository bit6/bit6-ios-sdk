//
//  Bit6AppDelegate.h
//  Bit6
//
//  Created by Carlos Thurber Boaventura on 06/06/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bit6CallViewController.h"

/*! Class to be extended by the ApplicationDelegate
 
 For example
 
    @interface AppDelegate : Bit6ApplicationManager <UIApplicationDelegate>
 
    @end
 
    @implementation AppDelegate
 
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
      [Bit6 init:@"your_api_key" pushNotificationMode:Bit6PushNotificationMode_DEVELOPMENT launchingWithOptions:launchOptions];
      return YES;
    }
 
    @end
 
 */
@interface Bit6ApplicationManager : UIResponder

/*! Bit6 implementation of -[UIApplicationDelegate application:didRegisterUserNotificationSettings:]
 @param application The app object that received the remote notification.
 @param notificationSettings The user notification settings that are available to your app. The settings in this object may be different than the ones you originally requested.
 @note Important: Remember to call super if you are going to implement your own -[UIApplicationDelegate application:didRegisterUserNotificationSettings:] method
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

/*! Bit6 implementation of -[UIApplicationDelegate application:handleActionWithIdentifier:forRemoteNotification:completionHandler:]
 @param application The app object that received the remote notification.
 @param identifier The identifier associated with the custom action.
 @param userInfo A dictionary that contains information related to the remote notification. This dictionary originates from the provider as a JSON-defined dictionary, which iOS converts to an NSDictionary object before calling this method. The contents of the dictionary are the push notification payload, which consists only of property-list objects plus NSNull.
 @param completionHandler The block to execute when you are finished performing the specified action. You must call this block at the end of your method.
 @note Important: Remember to call super if you are going to implement your own -[UIApplicationDelegate application:handleActionWithIdentifier:forRemoteNotification:completionHandler:] method
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler;

/*! Bit6 implementation of -[UIApplicationDelegate application:didReceiveRemoteNotification:]
 @param application The app object that received the remote notification.
 @param userInfo A dictionary that contains information related to the remote notification, potentially including a badge number for the app icon, an alert sound, an alert message to display to the user, a notification identifier, and custom data. The provider originates it as a JSON-defined dictionary that iOS converts to an NSDictionary object; the dictionary may contain only property-list objects plus NSNull.
 @note Important: Remember to call super if you are going to implement your own -[UIApplicationDelegate application:didReceiveRemoteNotification:] method
 */
- (void) application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

/*! To be called by the implementation of -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]
 @param userInfo A dictionary that contains information related to the remote notification, potentially including a badge number for the app icon, an alert sound, an alert message to display to the user, a notification identifier, and custom data. The provider originates it as a JSON-defined dictionary that iOS converts to an NSDictionary object; the dictionary may contain only property-list objects plus NSNull.
 @param completionHandler The block to execute when the download operation is complete. When calling this block, pass in the fetch result value that best describes the results of your download operation. You must call this handler and should do so as soon as possible.
 */
- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

/*! Bit6 implementation of -[UIApplicationDelegate application:didRegisterForRemoteNotificationsWithDeviceToken:]
 @param application The app object that initiated the remote-notification registration process.
 @param deviceToken A token that identifies the device to APS. The token is an opaque data type because that is the form that the provider needs to submit to the APS servers when it sends a notification to a device. The APS servers require a binary format for performance reasons.
 The size of a device token is 32 bytes.
 Note that the device token is different from the uniqueIdentifier property of UIDevice because, for security and privacy reasons, it must change when the device is wiped.
 @note Important: Remember to call super if you are going to implement your own -[UIApplicationDelegate application:didRegisterForRemoteNotificationsWithDeviceToken:] method
 */
- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

/*! Bit6 implementation of -[UIApplicationDelegate application:didFailToRegisterForRemoteNotificationsWithError:]
 @param application The app object that initiated the remote-notification registration process.
 @param error An NSError object that encapsulates information why registration did not succeed. The app can choose to display this information to the user.
 @note Important: Remember to call super if you are going to implement your own -[UIApplicationDelegate application:didFailToRegisterForRemoteNotificationsWithError:] method
 */
- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;

/*! Starting point of the incoming calls flow. Implement if you want to handle the entire flow.
 @param notification incoming call notification to be used with <[Bit6 callControllerFromIncomingCallNotification:]>
 */
- (void) receivedIncomingCallNotification:(NSNotification*)notification;

/*! Implement to customize the view controller used to handle the incoming call.
 @return a view controller to be used during the incoming call.
 */
- (Bit6CallViewController*) inCallViewController;

/*! Implement to customize the view show in the incoming call notification banner.
 @discussion  You should set this tags to your UI elements:
 <pre>
    title UILabel: tag=15
    message UILabel: tag=16
    decline UIButton: tag=17
    answer UIButton: tag=18
 </pre>
 @return a view to use in the incoming call notification banner.
 */
- (UIView*) incomingCallNotificationBannerContentView;

@end
