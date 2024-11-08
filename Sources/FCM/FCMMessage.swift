import Foundation

public typealias FCMMessageDefault = FCMMessage<FCMApnsPayload>

public struct FCMMessage<APNSPayload>: Sendable, Codable where APNSPayload: FCMApnsPayloadProtocol {
    /// Output Only.
    /// The identifier of the message sent,
    /// in the format of projects/*/messages/{message_id}.
    public let name: String
    
    /// Input only. Arbitrary key/value payload.
    public let data: [String: String]
    
    /// Input only.
    /// Basic notification template to use across all platforms.
    public let notification: FCMNotification?
    
    /// Input only.
    /// Android specific options for messages sent through FCM connection server.
    public var android: FCMAndroidConfig?
    
    /// Input only.
    /// Webpush protocol options.
    public var webpush: FCMWebpushConfig?
    
    /// Input only.
    /// Apple Push Notification Service specific options.
    public var apns: FCMApnsConfig<APNSPayload>?
    
    // MARK: - Union field target. Required. Input only. Target to send a message to. target can be only one of the following:
    
    /// Registration token to send a message to.
    public let token: String?
    
    /// Topic name to send a message to, e.g. "weather". Note: "/topics/" prefix should not be provided.
    public let topic: String?
    
    /// Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
    public let condition: String?
    
    /// Initialization with device token
    public init(token: String? = nil,
                notification: FCMNotification?,
                data: [String: String]? = nil,
                name: String? = nil,
                android: FCMAndroidConfig? = nil,
                webpush: FCMWebpushConfig? = nil,
                apns: FCMApnsConfig<APNSPayload>? = nil) {
        self.token = token
        self.notification = notification
        self.data = data ?? [:]
        self.name = name ?? UUID().uuidString
        self.android = android
        self.webpush = webpush
        self.apns = apns
        self.topic = nil
        self.condition = nil
    }
    
    /// Initialization with topic
    public init(topic: String,
                notification: FCMNotification?,
                data: [String: String]? = nil,
                name: String? = nil,
                android: FCMAndroidConfig? = nil,
                webpush: FCMWebpushConfig? = nil,
                apns: FCMApnsConfig<APNSPayload>? = nil) {
        self.topic = topic
        self.notification = notification
        self.data = data ?? [:]
        self.name = name ?? UUID().uuidString
        self.android = android
        self.webpush = webpush
        self.apns = apns
        self.condition = nil
        self.token = nil
    }
    
    /// Initialization with condition
    public init(condition: String,
                notification: FCMNotification?,
                data: [String: String]? = nil,
                name: String? = nil,
                android: FCMAndroidConfig? = nil,
                webpush: FCMWebpushConfig? = nil,
                apns: FCMApnsConfig<APNSPayload>? = nil)
    {
        self.condition = condition
        self.notification = notification
        self.data = data ?? [:]
        self.name = name ?? UUID().uuidString
        self.android = android
        self.webpush = webpush
        self.apns = apns
        self.token = nil
        self.topic = nil
    }
}

extension FCMMessage where APNSPayload == FCMApnsPayload {
    /// Initialization with device token
    public init(token: String,
                notification: FCMNotification?,
                data: [String: String]? = nil,
                name: String? = nil,
                android: FCMAndroidConfig? = nil,
                webpush: FCMWebpushConfig? = nil) {
        self.init(token: token,
                  notification: notification,
                  data: data,
                  name: name,
                  android: android,
                  webpush: webpush,
                  apns: FCMApnsConfig.default)
    }
    
    /// Initialization with topic
    public init(topic: String,
                notification: FCMNotification?,
                data: [String: String]? = nil,
                name: String? = nil,
                android: FCMAndroidConfig? = nil,
                webpush: FCMWebpushConfig? = nil) {
        self.init(topic: topic,
                  notification: notification,
                  data: data,
                  name: name,
                  android: android,
                  webpush: webpush,
                  apns: FCMApnsConfig.default)
    }
    
    /// Initialization with condition
    public init(condition: String,
                notification: FCMNotification?,
                data: [String: String]? = nil,
                name: String? = nil,
                android: FCMAndroidConfig? = nil,
                webpush: FCMWebpushConfig? = nil) {
        self.init(condition: condition,
                  notification: notification,
                  data: data,
                  name: name,
                  android: android,
                  webpush: webpush,
                  apns: FCMApnsConfig.default)
    }
}
