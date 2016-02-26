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