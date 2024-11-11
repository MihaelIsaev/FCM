[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/42512735-738605f4-8466-11e8-80ef-86394e852875.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-6.0-brightgreen.svg" alt="Swift 6.0">
    </a>
    <a href="https://discord.gg/q5wCPYv">
        <img src="https://img.shields.io/discord/612561840765141005" alt="Swift.Stream">
    </a>
</p>

<br>


# Intro 👏

It's a swift lib that gives ability to send push notifications through Firebase Cloud Messaging.

Built for Vapor4 and depends on `JWT` Vapor lib.

> 💡 Vapor3 version is available in **[vapor3](https://github.com/MihaelIsaev/FCM/tree/vapor3)** branch and from `1.0.0` tag
>
> 💡 Stable Vapor4 ELF version is available in **[v2](https://github.com/MihaelIsaev/FCM/tree/v2)** branch and from `2.0.0` tag

If you have great ideas of how to improve this package write me (@iMike#3049) in [Vapor's discord chat](http://vapor.team) or just send pull request.

Hope it'll be useful for someone :)

### Install through Swift Package Manager ❤️

Edit your `Package.swift`

```swift
//add this repo to dependencies
.package(url: "https://github.com/MihaelIsaev/FCM.git", from: "3.0.0-beta.1")
//and don't forget about targets
.product(name: "FCM", package: "FCM")
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
    /// with service account json string
    /// put into your environment variable the following key:
    /// FCM_SERVICE_ACCOUNT_KEY="{"prohect_id": "my_project123",...}"
    app.fcm.configuration = .envServiceAccountKey
    
    /// case 3
    /// put into your environment variables the following keys:
    /// FCM_EMAIL=...          // `client_email` in service.json
    /// FCM_PROJECT_ID=...     // `project_id` in service.json
    /// FCM_PRIVATE_KEY=...    // `private_key` in service.json
    app.fcm.configuration = .envServiceAccountKeyFields

    /// case 4
    /// put into your environment variables the following keys:
    /// FCM_EMAIL=...
    /// FCM_PROJECT_ID=...
    /// FCM_KEY_PATH=path/to/key.pem
    app.fcm.configuration = .envCredentials

    /// case 5
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

func routes(_ app: Application) async throws {
    app.get("testfcm") { req async throws -> String in
        let token = "<YOUR FIREBASE DEVICE TOKEN>" // get it from iOS/Android SDK
        let notification = FCMNotification(title: "Vapor is awesome!", body: "Swift one love! ❤️")
        let message = FCMMessage(token: token, notification: notification)
        let name = try await req.fcm.send(message, on: req.eventLoop)
        return "Just sent: \(name)"
    }
}
```

`fcm.send` returns message name like `projects/example-3ab5c/messages/1531222329648135`

`FCMMessage` struct is absolutely the same as `Message` struct in Firebase docs https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
So you could take a look on its source code to build proper message.

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
let tokens = try await application.fcm.registerAPNS(.env, tokens: "token1", "token3", ..., "token100")
/// `tokens` is array of `APNSToFirebaseToken` structs
/// which contains:
/// registration_token - Firebase token
/// apns_token - APNS token
/// isRegistered - boolean value which indicates if registration was successful

/// instead of .env you could declare your own identifier
extension RegisterAPNSID {
   static var myApp: RegisterAPNSID { .init(appBundleId: "com.myapp") }
}

/// Advanced way
let tokens = try await application.fcm.registerAPNS(
    appBundleId: String, // iOS app bundle identifier
    serverKey: String?, // optional server key, if nil then env variable will be used
    sandbox: Bool, // optional sandbox key, false by default
    tokens: [String]
)
/// the same as in above example
```

> 💡 Please note that push token taken from Xcode while debugging is for `sandbox`, so either use `.envSandbox` or don't forget to set `sandbox: true`

## Contributors

Thanks to these amazing people for their contributions:

- **[@ptoffy](https://github.com/ptoffy)** for enhancements in Swift 6 support [#50](https://github.com/MihaelIsaev/FCM/pull/50)
- **[@gennaro-safehill](https://github.com/gennaro-safehill)** for Swift 6 and async/await support [#48](https://github.com/MihaelIsaev/FCM/pull/48)
- **[@paunik](https://github.com/paunik)** for adding image support in options [#44](https://github.com/MihaelIsaev/FCM/pull/44)
- **[@chinh-tran](https://github.com/chinh-tran)** for retrieving subscribed topics [#43](https://github.com/MihaelIsaev/FCM/pull/43)
- **[@apemaia99](https://github.com/apemaia99)** for supporting multiple configurations/clients [#42](https://github.com/MihaelIsaev/FCM/pull/42)
- **[@sroebert](https://github.com/sroebert)** for removing unneeded setting of `ignoreUncleanSSLShutdown` [#36](https://github.com/MihaelIsaev/FCM/pull/36)
- **[@sroebert](https://github.com/sroebert)** for marking all `FCMAndroidConfig` fields as optional [#34](https://github.com/MihaelIsaev/FCM/pull/34)
- **[@JCTec](https://github.com/JCTec)** for Swift 5.2.1 support [#33](https://github.com/MihaelIsaev/FCM/pull/33)
- **[@Andrewangeta](https://github.com/Andrewangeta)** for reading service account from JSON string env variable [#31](https://github.com/MihaelIsaev/FCM/pull/31)
- **[@siemensikkema](https://github.com/siemensikkema)** for batch messaging improvements [#30](https://github.com/MihaelIsaev/FCM/pull/30)
- **[@krezzoid](https://github.com/krezzoid)** for token issue decoding fix [#27](https://github.com/MihaelIsaev/FCM/pull/27)
- 💎 **[@grahamburgsma](https://github.com/grahamburgsma)** for fixing memory issues [#26](https://github.com/MihaelIsaev/FCM/pull/26)
- **[@geeksweep](https://github.com/geeksweep)**, **[@maximkrouk](https://github.com/maximkrouk)**, **[@gustavoggs](https://github.com/gustavoggs)** for README updates [#22](https://github.com/MihaelIsaev/FCM/pull/22), [#23](https://github.com/MihaelIsaev/FCM/pull/23), [#37](https://github.com/MihaelIsaev/FCM/pull/37)
- **[@emrahsifoglu](https://github.com/emrahsifoglu)** for optional `priority` option [#20](https://github.com/MihaelIsaev/FCM/pull/20)
- **[@nerzh](https://github.com/nerzh)** for enhancements in `FCMAndroidNotification` [#16](https://github.com/MihaelIsaev/FCM/pull/16), [#18](https://github.com/MihaelIsaev/FCM/pull/18)
- **[@FredericRuaudel](https://github.com/FredericRuaudel)** for multiple useful enhancements [#13](https://github.com/MihaelIsaev/FCM/pull/13), [#14](https://github.com/MihaelIsaev/FCM/pull/14), [#15](https://github.com/MihaelIsaev/FCM/pull/15)
- **[@grahamburgsma](https://github.com/grahamburgsma)** for `GoogleError` and `FCMError` [#10](https://github.com/MihaelIsaev/FCM/pull/10)
- **[@simonmitchell](https://github.com/simonmitchell)** for capability for silent `content-available` push notifications [#9](https://github.com/MihaelIsaev/FCM/pull/9)
- **[@siemensikkema](https://github.com/siemensikkema)** for updating to JWT `v3` [#3](https://github.com/MihaelIsaev/FCM/pull/3)
- **[@pedantix](https://github.com/pedantix)** for `APNS` enhancements [#2](https://github.com/MihaelIsaev/FCM/pull/2)
