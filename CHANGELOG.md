## 0.10.0 [2016-09-08]

### Breaking Changes
- The `Bit6.pushNotification` methods to handle push notifications have been renamed, for example from `didReceiveRemoteNotification:fetchCompletionHandler:` to `didReceiveNotificationUserInfo:fetchCompletionHandler:`. See the sample apps for the complete implementation.
- On iOS10 it's necessary to implement `[UIApplicationDelegate application:didReceiveRemoteNotification:]` and in it to call `[Bit6.pushNotification didReceiveNotificationUserInfo:];`
- Dropped iOS7 support.
- `Bit6.callcontrollers` now return all the calls: inactive / actives / ended. To get the list of active calls use `Bit6.activeCalls` instead.
- `Bit6CallState_MISSED` and `Bit6CallState_ERROR` were replaced by `Bit6CallController.missed` and `Bit6CallController.error` properties.
- `Bit6RTStatus` enum replaced by `Bit6WebSocketReadyState`.
- Bit6CallController.decline() has been replaced by Bit6CallController.hangup()
- Incoming calls from `Bit6IncomingCallNotification` no longer set the remoteStreams automatically. Before answering the call remember to do `call.remoteStreams = call.availableStreamsForIncomingCall;` and `call.localStreams = call.availableStreamsForIncomingCall`.
- Bit6TransferUpdateNotification has been removed. Use `Bit6CallControllerDelegate` instead.

### Features (Core)
- VoIP Push Notifications support for incoming calls. Please follow this [guide](http://docs.bit6.com/guides/push-apns/#environments) to configure it. Also now, in your ApplicationDelegate you need to handle local notifications, please see [Push Notifications](http://docs.bit6.com/guides/ios-intro/#application-delegate).
- New methods to detect when the local video feed is interrupted by the system.
- new method Bit6Group.setRole:forMember:completion: to change a member role in a group.

### Bugfixes (Core)
- Issues with resize of video feeds for rotation in Bit6CallViewController
- Issues to mark individual messages as READ.
- The automatic download of attachments could happen before setting Bit6.setDownloadAudioRecordings() property and others
- Issues with video interruptions during a call could cause the local video feed to not be restored.
- Bit6Group.createGroupWithMetadata:completion: wasn't setting the metadata after creating the group.

### Features (UI)
- support for Bit6.setDownloadAudioRecordings()
- BXUMessageTableViewController now has methods to customize the supported attachments.
- BXUMessageTableViewController now can show a single emoji message 3x its size using the property `biggerEmojis`.

### Bugfixes (UI)
- BXUContactAvatarImageView initials label weren't shown centered
- On BXUConversationList, if the cell is showing "typing" and the user selects the cell you can see the last message on top of "typing" label.

## 0.9.8 [2016-05-24]

### Changes (Core)
- `[Bit6CallController callStateChangedNotificationForCall:]` and `[Bit6CallController secondsChangedNotificationForCall]` are now deprecated in favor of `Bit6CallControllerDelegate`.
- It's not recommented the usage of KVO to listen to Bit6CallController notifications. Now `[callController addObserver:... forKeyPath:@"state" options:NSKeyValueObservingOptionOld context:NULL]` should be replaced by the usage of `Bit6CallControllerDelegate`.

### Changes (UI)
- BXUWebSocketStatusLabel now uses a delegate to customize its behavior instead of `viewsWhileConnecting` and `viewsWhenConnected` properties.
- BXUIncomingCallPrompt is now customizable by using `setContentViewGenerator(frame)` instead of `setContentView()`.

### Bugfixes (Core)
- DataChannel transfer fails in the initial seconds of a call
- callController.otherDisplayName could be reset to nil for Missed Calls
- calls might not connect if Bit6.session.activeDisplayName was used

### Bugfixes (UI)
- BXUIncomingCallPrompt now can answer audio and video calls with data stream component.
- Setting callController.otherDisplayName in BXUIncomingCallPrompt only works for existing BXUContacts
- BXUIncomingCallPrompt wasn't shown in the center of the application if the application was running in iOS9 SlideOver or SplitView.



## 0.9.7 [2016-04-22]

### Breaking Changes
- All UI related classes (like Bit6ThumbnailImageView and Bit6ImageView) have been moved to UI lib.
- To handle incoming calls and to prepare the in-call UI you need to register for `Bit6IncomingCallNotification` and `Bit6CallAddedNotification`. To handle errors because of video and mic restricted access you can listen to `Bit6CallPermissionsMissingNotification`.
- [Bit6 createCallTo:streams:] replaced with [Bit6 startCallTo:streams:] and [Bit6 createCallToPhoneNumber:] replaced with [Bit6 startPhoneCallTo:]. 
- To use an in-call viewcontroller its classname must be set in your target's info.plist and then call `[Bit6 createViewControllerForCall]` to create the object.
- Bit6CallViewController subclasses need to implement `callStateChangedNotificationForCall:` and `secondsChangedNotificationForCall:` instead of `callStateChangedNotificationForCallController:` and `secondsChangedNotificationForCallController:`. Please check the startup guide for a complete list of necessary methods to implement.
- Added localization to messages and calls. A Localizable.strings file is needed in the project (see sample apps)
- Bit6CallController.callState has been renamed to Bit6CallController.state, please make sure this is considered if listening to KVO notifications.

### Features
- Support for quick reply in message push notifications
- Methods to handle the cache directory: cacheSize(), numberOfItemsInCache() and clearCache()

### Bugfixes
- Bit6.presentCallViewController() doesn't present the in-call screen if there's a UIViewController being presented modally.
- 'decline' option in push notifications for incoming calls doesn't work.
- Bit6Session.publicProfile has no content after a login through facebook and other services.
- fails to detect when a push notification has been tapped by the user or not.
- push notifications aren't sent correcly when apps are running in AdHoc distributions
- issues with video feeds inside in-call screen when using it for many calls.

## 0.9.6 [2016-02-13]

### Features
- Framework is built using Modules, so it's easy to import to your Swift projects.
- Many API improvements in the SDK to make it work better when working with Optionals and collections in Swift.
- Simpler API to start the Bit6 service.
- Easier to clear the unread messages badge from a conversation object.
- A more generic API using Bit6CallStreams to do calls with different streams: Audio, Video and Data.
- Cleaner APIs for the creation of Bit6Address objects.
- Bit6AudioPlayerController and Bit6AudioRecorderController now work without requering a Bit6Message object.
- More robust list of statuses for Bit6CallController objects.
- Added API to enable audio through bluetooth devices during a call.
- Improved API to start a Bit6OutgoingTransfer.
- Easier implementation of a custom incoming call handlers.
- New customizable Bit6IncomingCallPrompt to show a nice looking prompt when an incoming call arrives.
- New Bit6FileDownloader class to add downloads of any file to the main queue.
- Cleaner API to get the path and status attachment of Bit6Message.
- Bit6Session now supports external authentication providers like
Digits, Telerik, Parse and others.

### Bugfixes
- Calls not connecting
- Syncing of groups members and roles fail from time to time.
- Ringtone sound goes through earphone instead of speaker.