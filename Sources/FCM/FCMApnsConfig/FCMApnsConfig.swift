import Foundation

public struct FCMApnsConfig<P>: Sendable, Codable where P: FCMApnsPayloadProtocol & Sendable {
    /// HTTP request headers defined in Apple Push Notification Service.
    /// Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String]
    
    /// APNs payload as a JSON object, including both aps dictionary and custom payload.
    /// See Payload Key Reference. If present, it overrides FCMNotification.title and FCMNotification.body.
    public var payload: P

    /// FCM Options to send meta data
    public var options: FCMOptions?

    // MARK: - Public Initializers
    
    /// Use this if you need custom payload
    /// Your payload should conform to FCMApnsPayloadProtocol
    public init(headers: [String: String]? = nil, payload: P, options: FCMOptions? = nil) {
        self.headers = headers ?? [:]
        self.payload = payload
        self.options = options
    }

    enum CodingKeys: String, CodingKey {
        case options = "fcm_options"
        case headers
        case payload
    }
}

extension FCMApnsConfig where P == FCMApnsPayload {
    /// Use this if you need only aps object
    public init(headers: [String: String]? = nil, aps: FCMApnsApsObject? = nil, options: FCMOptions? = nil) {
        if let aps {
            self.init(headers: headers, payload: FCMApnsPayload(aps: aps), options: options)
        } else {
            self.init(headers: headers, payload: FCMApnsPayload(), options: options)
        }
    }
    
    /// Returns an instance with default values
    public static var `default`: FCMApnsConfig {
        FCMApnsConfig()
    }
}
