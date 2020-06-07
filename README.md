[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/42512735-738605f4-8466-11e8-80ef-86394e852875.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
    </a>
    <a href="https://discord.gg/q5wCPYv">
        <img src="https://img.shields.io/badge/CLICK_HERE_TO_DISCUSS_THIS_LIB-SWIFT.STREAM-FD6F32.svg" alt="Swift.Stream">
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
.package(url: "https://github.com/MihaelIsaev/FCM.git", from: "2.7.0")
//and don't forget about targets
//.product(name: "FCM", package: "FCM")
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
    /// FCM_EMAIL=...          // `client_email` in service.json
    /// FCM_PROJECT_ID=...     // `project_id` in service.json
    /// FCM_PRIVATE_KEY=...    // `private_key` in service.json
    app.fcm.configuration = .envServiceAccountKeyFields

    /// case 3
    /// put into your environment variables the following keys:
    /// FCM_EMAIL=...
    /// FCM_PROJECT_ID=...
    /// FCM_KEY_PATH=path/to/key.pem
    app.fcm.configuration = .envCredentials

    /// case 4
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
app.fcm.configuration?.apnsDefaultConfig = FCMApnsConfig(headers: [:], 
                                                         aps: FCMApnsApsObject(sound: "default"))

app.fcm.configuration?.androidDefaultConfig = FCMAndroidConfig(ttl: "86400s",
                                                               restricted_package_name: "com.example.myapp",
                                                               notification: FCMAndroidNotification(sound: "default"))
                                                
app.fcm.configuration?.webpushDefaultConfig = FCMWebpushConfig(headers: [:],
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
        return req.fcm.send(message, on: req.eventLoop).map { name in
            return "Just sent: \(name)"
        }
    }
}
```

`fcm.send` returns message name like `projects/example-3ab5c/messages/1531222329648135`

`FCMMessage` struct is absolutely the same as `Message` struct in Firebase docs https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
So you could take a look on its source code to build proper message.

# Batch sending

### Preparation

1. Go to [Firebase Console](https://console.firebase.google.com/) -> Project Settings -> Cloud Messaging tab
2. Copy `Server Key` from `Project Credentials` area
3. Put server key into environment variables as `FCM_SERVER_KEY=<YOUR_SERVER_KEY>` (or put it into `serviceAccountKey.json` file as `server_key`)

### Sending

```swift
// get it from iOS/Android SDK
let token1 = "<YOUR FIREBASE DEVICE TOKEN>"
let token2 = "<YOUR FIREBASE DEVICE TOKEN>"
let token3 = "<YOUR FIREBASE DEVICE TOKEN>"
...
let token100500 = "<YOUR FIREBASE DEVICE TOKEN>"

let notification = FCMNotification(title: "Life is great! 😃", body: "Swift one love! ❤️")
let message = FCMMessage(notification: notification)
application.fcm.batchSend(message, tokens: [token1, token2, token3, ..., token100500]).map {
    print("sent!")
}
```

# APNS to Firebase token conversion

You can throw away Firebase libs from dependencies of your iOS apps because you can send pure APNS tokens to your server and it will register it in Firebase by itself.

It is must have for developers who don't want to add Firebase libs into their apps, and especially for iOS projects who use Swift Package Manager cause Firebase doesn't have SPM support for its libs yet.

## How to use

### Preparation

1. Go to [Firebase Console](https://console.firebase.google.com/) -> Project Settings -> Cloud Messaging tab
2. Copy `Server Key` from `Project Credentials` area

Next steps are optional

3. Put server key into environment variables as `FCM_SERVER_KEY=<YOUR_SERVER_KEY>` (or put it into `serviceAccountKey.json` file as `server_key`)
4. Put your app bundle identifier into environment variables as `FCM_APP_BUNDLE_ID=<APP_BUNDLE_ID>`

### Tokens registration

```swift
/// The simplest way
/// .env here means that FCM_SERVER_KEY and FCM_APP_BUNDLE_ID will be used
application.fcm.registerAPNS(.env, tokens: "token1", "token3", ..., "token100").flatMap { tokens in
    /// `tokens` is array of `APNSToFirebaseToken` structs
    /// which contains:
    /// registration_token - Firebase token
    /// apns_token - APNS token
    /// isRegistered - boolean value which indicates if registration was successful
}

/// instead of .env you could declare your own identifier
extension RegisterAPNSID {
   static var myApp: RegisterAPNSID { .init(appBundleId: "com.myapp") }
}

/// Advanced way
application.fcm.registerAPNS(
    appBundleId: String, // iOS app bundle identifier
    serverKey: String?, // optional server key, if nil then env variable will be used
    sandbox: Bool, // optional sandbox key, false by default
    tokens: [String], // an array of APNS tokens
    on: EventLoop? // optional event loop, if nil then application.eventLoopGroup.next() will be used
).flatMap { tokens in
    /// the same as in above example
}
```

> 💡 Please note that push token taken from Xcode while debugging is for `sandbox`, so either use `.envSandbox` or don't forget to set `sandbox: true`

## Contributors

> Special thanks to @grahamburgsma for `GoogleError` and `FCMError` #10
