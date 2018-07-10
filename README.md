[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/42512735-738605f4-8466-11e8-80ef-86394e852875.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-4.1-brightgreen.svg" alt="Swift 4.1">
    </a>
    <a href="https://twitter.com/VaporRussia">
        <img src="https://img.shields.io/badge/twitter-VaporRussia-5AA9E7.svg" alt="Twitter">
    </a>
</p>

<br>


# Intro

It's a swift lib that gives ability to send push notifications through Firebase Cloud Messaging.

Built for Vapor3 and depends on `JWT` Vapor lib.

Note: the project is in active development state and it may cause huge syntax changes before v1.0.0

If you have great ideas of how to improve this package write me (@iMike) in [Vapor's discord chat](http://vapor.team) or just send pull request.

Hope it'll be useful for someone :)

### Install through Swift Package Manager

Edit your `Package.swift`

```swift
//add this repo to dependencies
.package(url: "https://github.com/MihaelIsaev/FCM.git", from: "0.1.0")
//and don't forget about targets
//"FCM"
```

### How it works

First of all you should configure FCM in `configure.swift`

```swift
import FCM

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
//here you should initialize FCM
}
```

There are two ways

1. Manually
```swift
let fcm = FCM(email: "firebase-adminsdk-0w4ba@example-3ab5c.iam.gserviceaccount.com",
              projectId: "example-3ab5c",
              pathToKey: "/tmp/fcm.pem")
services.register(fcm, as: FCM.self)
```
2. Using environment variables
```swift
let fcm = FCM()
services.register(fcm, as: FCM.self)
```
and don't forget to pass the following environment variables
```swift
fcmEmail // firebase-adminsdk-0w4ba@example-3ab5c.iam.gserviceaccount.com
fcmKeyPath // /tmp/fcm.pem
fcmProjectId // example-3ab5c
```

Then you could send push notifications using token, topic or condition.

Here's an example route handler with push notification sending using token

```swift
router.get("testfcm") { req -> Future<String> in
  let fcm = try req.make(FCM.self)
  let token = "c2BSqPOBoig:APA91bEMxvozKLY9DKjYpdHR8yjR0DScIDd7vqd-WSIsct4UHDT1U7cQU1n3PAwfSAlaH-UUTuX3x18oa5IF1pB2KmAQb-pIiSEX7NVh90IhbCVO7Fp30hguKUhzDum95WVw0MA385QgvCZWLCDx7540yPlD_5HU6g"
  let message = Message(token: token, notification: Notification(title: "Vapor is awesome!", body: "Swift one love! ❤️"))
  return try fcm.sendMessage(req.client(), message: message)
}
```

`fcm.sendMessage` returns message name like `projects/example-3ab5c/messages/1531222329648135`

`Message` struct is absolutely the same as in Firebase docs https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
So you could take a look on its source code to build proper message.
