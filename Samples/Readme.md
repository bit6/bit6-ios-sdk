Sample Apps
=============

The sample apps are made as simple as possible to demonstrate the use of the Bit6 SDK. The interface is therefore minimalistic and only includes the essential elements.

You will be able to send text, photo, video, voice messages, location, make audio and video calls between the two users and make outgoing phone calls. For the ultimate experience you need to upload the APNS certificate.

### Bit6ChatDemo and Bit6ChatDemo-Swift

You will be able to send text, photo, video, voice messages, and location between the two users.

To see the sample app in action, you will need to create two users:

* Open the Bit6 sample app
* Tap 'Sign up'
* Type a username and a password, then 'Done'

####To start a conversation:
1. Tap the '+' button in the upper right corner
2. Type the destination user

####To send a text message:
1. Tap the "compose" button in the lower right corner
2. Type your message and tap "send"

####To send an attachment:
1. Tap the "+" button in the lower left corner
2. Choose between the options available: Take Photo/Video, Select Image/Video, Record Audio, Send Current Location

* You can see the attachment in full size by tapping the thumbnail image. If the attachment is an audio/video file it will start playing, if it is a location it will be opened in the Maps app.
* Forward/Copy/Resend menu appears if you tap and hold the thumbnail or text within a message.

 
### Bit6CallDemo and Bit6CallDemo-Swift

This demo allows to make audio and video calls to another user and make outgoing phone calls.

To see the sample app in action, you will need to create two users:
* Open the Bit6 sample app
* Tap 'Sign up'
* Type a username and a password, then 'Done'

####To make an audio/video call to another user:
1. Fill the "Username to call" field
2. Tap the "Audio call" or "Video call" button
3. During the call you will be able to mute the call or use the speaker.

####To answer/decline a call:
* If call is received while using the app, a prompt will be shown.
* If call is received while the app is not in use, a notification will be shown. You can see the answer/decline actions if you swipe down the notification on the home screen or swipe left on the lock screen.

####To make a call to a phone number:
1. Fill the "+13334445555" field with the phone number to call. Phone numbers must be in [E164](http://en.wikipedia.org/wiki/E.164) format, prefixed with +.
2. Tap the "Dial Phone Number" button

__Note.__ For the test purposes we allow short 1 minute calls to destinations in US and Canada. In later releases we will also add billing, which will in turn allow to connect calls of any length to any destination number.

### FBVideoCallsDemo

This demo allow you to make audio and video calls to another facebook user using the app as follows:

1. Open the Bit6 sample app
2. Tap 'Start Calling', you will be redirected to login to Facebook
3. After you return to the app you will see all the facebook contacts available to call. The facebook contacts need to complete the steps above to be able to receive video calls.

### DigitsDemo, ParseDemo and TelerikDemo

These demos allow you to OAuth login and make audio and video calls to another user using the app as follows:

1. Open the Bit6 sample app
2. Tap 'Sign up'
3. Enter your Digits/Parse/Telerik credentials.
4. After you return to the app you will see all the facebook contacts available to call. The facebook contacts need to complete the steps above to be able to receive video calls.


####To make an audio/video call to another user:
1. Fill the "Username to call" field
2. Tap the "Audio call" or "Video call" button
3. During the call you will be able to mute the call or use the speaker.

####To answer/decline a call:
* If call is received while using the app, a prompt will be shown.
* If call is received while the app is not in use, a notification will be shown. You can see the answer/decline actions if you swipe down the notification on the home screen or swipe left on the lock screen.

####To make a call to a phone number:
1. Fill the "+13334445555" field with the phone number to call. Phone numbers must be in [E164](http://en.wikipedia.org/wiki/E.164) format, prefixed with +.
2. Tap the "Dial Phone Number" button

__Note.__ For the test purposes we allow short 1 minute calls to destinations in US and Canada. In later releases we will also add billing, which will in turn allow to connect calls of any length to any destination number.


### DataChannelDemo

This demo show how to make a data call to transfer images to another user using the app as follows:

1. Open the Bit6 sample app
2. Enter your credentials to login or sign up, or choose Anonymous to perform an authentication without user+password.
3. Enter the user to call in the "destination" field and press 'Connect'
4. After the destination answer the call you can start an image transfer by tapping the 'camera' button and select a picture. You will see the progress of the transfer in the screen and the image will appear once the transfer is completed.