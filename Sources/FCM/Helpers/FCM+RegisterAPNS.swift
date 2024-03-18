import Foundation
import Vapor

public struct RegisterAPNSID {
    let appBundleId: String
    let serverKey: String?
    let sandbox: Bool

    public init (appBundleId: String, serverKey: String? = nil, sandbox: Bool = false) {
        self.appBundleId = appBundleId
        self.serverKey = serverKey
        self.sandbox = sandbox
    }
}

extension RegisterAPNSID {
    public static var env: RegisterAPNSID {
        guard let appBundleId = Environment.get("FCM_APP_BUNDLE_ID") else {
            fatalError("FCM: Register APNS: missing FCM_APP_BUNDLE_ID environment variable")
        }
        return .init(appBundleId: appBundleId)
    }
}

extension RegisterAPNSID {
    public static var envSandbox: RegisterAPNSID {
        let id: RegisterAPNSID = .env
        return .init(appBundleId: id.appBundleId, sandbox: true)
    }
}

public struct APNSToFirebaseToken {
    public let registration_token, apns_token: String
    public let isRegistered: Bool
}

extension FCM {
    /// Helper method which registers your pure APNS token in Firebase Cloud Messaging
    /// and returns firebase tokens for each APNS token
    ///
    /// Convenient way
    ///
    /// Declare `RegisterAPNSID` via extension
    /// ```swift
    /// extension RegisterAPNSID {
    ///     static var myApp: RegisterAPNSID { .init(appBundleId: "com.myapp") }
    /// }
    /// ```
    ///
    public func registerAPNS(
        _ id: RegisterAPNSID,
        tokens: String...,
        on eventLoop: EventLoop? = nil) -> EventLoopFuture<[APNSToFirebaseToken]> {
        registerAPNS(appBundleId: id.appBundleId, serverKey: id.serverKey, sandbox: id.sandbox, tokens: tokens, on: eventLoop)
    }

    /// Helper method which registers your pure APNS token in Firebase Cloud Messaging
    /// and returns firebase tokens for each APNS token
    ///
    /// Convenient way
    ///
    /// Declare `RegisterAPNSID` via extension
    /// ```swift
    /// extension RegisterAPNSID {
    ///     static var myApp: RegisterAPNSID { .init(appBundleId: "com.myapp") }
    /// }
    /// ```
    ///
    public func registerAPNS(
        _ id: RegisterAPNSID,
        tokens: [String],
        on eventLoop: EventLoop? = nil) -> EventLoopFuture<[APNSToFirebaseToken]> {
        registerAPNS(appBundleId: id.appBundleId, serverKey: id.serverKey, sandbox: id.sandbox, tokens: tokens, on: eventLoop)
    }

    /// Helper method which registers your pure APNS token in Firebase Cloud Messaging
    /// and returns firebase tokens for each APNS token
    public func registerAPNS(
        appBundleId: String,
        serverKey: String? = nil,
        sandbox: Bool = false,
        tokens: String...,
        on eventLoop: EventLoop? = nil) -> EventLoopFuture<[APNSToFirebaseToken]> {
        registerAPNS(appBundleId: appBundleId, serverKey: serverKey, sandbox: sandbox, tokens: tokens, on: eventLoop)
    }

    /// Helper method which registers your pure APNS token in Firebase Cloud Messaging
    /// and returns firebase tokens for each APNS token
    public func registerAPNS(
        appBundleId: String,
        serverKey: String? = nil,
        sandbox: Bool = false,
        tokens: [String],
        on eventLoop: EventLoop? = nil) -> EventLoopFuture<[APNSToFirebaseToken]> {
        let eventLoop = eventLoop ?? client.eventLoop
        guard tokens.count <= 100 else {
            return eventLoop.makeFailedFuture(Abort(.internalServerError, reason: "FCM: Register APNS: tokens count should be less or equeal 100"))
        }
        guard tokens.count > 0 else {
            return eventLoop.future([])
        }
        
        guard let serverKey = serverKey ?? configuration.serverKey else {
            fatalError("FCM: Register APNS: Server Key is missing.")
        }
        let url = iidURL + "batchImport"

        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "key=\(serverKey)")

        return self.client.post(URI(string: url), headers: headers) { (req) in
            struct Payload: Content {
                let application: String
                let sandbox: Bool
                let apns_tokens: [String]
            }
            let payload = Payload(application: appBundleId, sandbox: sandbox, apns_tokens: tokens)
            try req.content.encode(payload)
        }
        .validate()
        .flatMapThrowing { res in
            struct Result: Codable {
                struct Result: Codable {
                    let registration_token, apns_token, status: String
                }
                let results: [Result]
            }
            let result = try res.content.decode(Result.self)
            return result.results.map {
                .init(registration_token: $0.registration_token, apns_token: $0.apns_token, isRegistered: $0.status == "OK")
            }
        }
    }
}
