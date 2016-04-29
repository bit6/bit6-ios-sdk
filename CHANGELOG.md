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