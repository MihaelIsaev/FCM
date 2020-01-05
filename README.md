[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/42512735-738605f4-8466-11e8-80ef-86394e852875.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
    <a href="https://twitter.com/VaporRussia">
        <img src="https://img.shields.io/badge/twitter-VaporRussia-5AA9E7.svg" alt="Twitter">
    </a>
</p>

<br>


# Intro 👏

It's a swift lib that gives ability to send push notifications through Firebase Cloud Messaging.

Built for Vapor4 and depends on `JWT` Vapor lib.

> 💡Vapor3 version is available in `vapor3` branch and from `1.0.0` tag

If you have great ideas of how to improve this package write me (@iMike#3049) in [Vapor's discord chat](http://vapor.team) or just send pull request.

Hope it'll be useful for someone :)

### Install through Swift Package Manager ❤️

Edit your `Package.swift`

```swift
//add this repo to dependencies
.package(url: "https://github.com/MihaelIsaev/FCM.git", from: "2.0.0")
//and don't forget about targets
//"FCM"
```

### How it works ?

First of all you should configure FCM in `configure.swift`

```swift
import FCM

// Called before your application initializes.
func configure(_ app: Application) throws {
    /// case 1
    /// with service account json file
    /// put into your environment variables the following key:
    /// FCM_SERVICE_ACCOUNT_KEY_PATH=path/to/serviceAccountKey.json
    app.fcm.configuration = .envServiceAccountKey

    /// case 2
    /// put into your environment variables the following keys:
    /// FCM_EMAIL=...
    /// FCM_PROJECT_ID=...
    /// FCM_KEY_PATH=path/to/key.pem
    app.fcm.configuration = .envCredentials

    /// case 3
    /// manually
    app.fcm.configuration = .init(email: "...", projectId: "...", key: "...")
}
```

> ⚠️ **TIP:** `serviceAccountKey.json` you could get from [Firebase Console](https://console.firebase.google.com)
>
> 🔑 Just go to Settings -> Service Accounts tab and press **Create Private Key** button in e.g. NodeJS tab

#### OPTIONAL: Set default configurations, e.g. to enable notification sound
Add the following code to your `configure.swift` after `app.fcm.configuration = ...`
```swift
app.fcm.apnsDefaultConfig = FCMApnsConfig(headers: [:],
                                          aps: FCMApnsApsObject(sound: "default"))
app.fcm.androidDefaultConfig = FCMAndroidConfig(ttl: "86400s",
                                                restricted_package_name: "com.example.myapp",
                                                notification: FCMAndroidNotification(sound: "default"))
app.fcm.webpushDefaultConfig = FCMWebpushConfig(headers: [:],
                                                data: [:],
                                                notification: [:])
```
#### Let's send first push notification! 🚀

Then you could send push notifications using token, topic or condition.

Here's an example route handler with push notification sending using token

```swift
import FCM

func routes(_ app: Application) throws {
    app.get("testfcm") { req -> EventLoopFuture<String> in
        let token = "<YOUR FIREBASE DEVICE TOKEN>" // get it from iOS/Android SDK
        let notification = FCMNotification(title: "Vapor is awesome!", body: "Swift one love! ❤️")
        let message = FCMMessage(token: token, notification: notification)
        return req.fcm.send(message).map { name in
            return "Just sent: \(name)"
        }
    }
}
```

`fcm.send` returns message name like `projects/example-3ab5c/messages/1531222329648135`

`FCMMessage` struct is absolutely the same as `Message` struct in Firebase docs https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
So you could take a look on its source code to build proper message.

> Special thanks to @grahamburgsma for `GoogleError` and `FCMError` #10
