import Foundation

final public class FCMApnsConfig<P>: Codable where P: FCMApnsPayloadProtocol {
    /// HTTP request headers defined in Apple Push Notification Service.
    /// Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String]
    
    /// APNs payload as a JSON object, including both aps dictionary and custom payload.
    /// See Payload Key Reference. If present, it overrides FCMNotification.title and FCMNotification.body.
    public var payload: P

    //MARK: - Public Initializers
    
    /// Use this if you need custom payload
    /// Your payload should conform to FCMApnsPayloadProtocol
    public init(headers: [String: String]? = nil, payload: P) {
        self.headers = headers ?? [:]
        self.payload = payload
    }
}

extension FCMApnsConfig where P == FCMApnsPayload {
    /// Use this if you need only aps object
    public convenience init(headers: [String: String]? = nil, aps: FCMApnsApsObject? = nil) {
        if let aps = aps {
            self.init(headers: headers, payload: FCMApnsPayload(aps: aps))
        } else {
            let aps = FCMApnsApsObject(config: nil)
            let paylaod = FCMApnsPayload(aps: aps)
            self.init(headers: headers, payload: paylaod)
        }
    }
    
    /// Returns an instance with default values
    public static var `default`: FCMApnsConfig {
        return FCMApnsConfig()
    }
}
