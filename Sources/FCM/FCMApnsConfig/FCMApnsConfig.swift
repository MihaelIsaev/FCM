import Foundation

final public class FCMApnsConfig<P>: Codable where P: FCMAPNSPayloadProtocol {
    /// HTTP request headers defined in Apple Push Notification Service.
    /// Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    
    /// APNs payload as a JSON object, including both aps dictionary and custom payload.
    /// See Payload Key Reference. If present, it overrides FCMNotification.title and FCMNotification.body.
    public var payload: P

    //MARK: - Public Initializers
    
    /// Use this if you need custom payload
    /// Your payload should conform to FCMAPNSPayloadProtocol
    public init(headers: [String: String] = [:], payload: P) {
        self.headers = headers
        self.payload = payload
    }
}

extension FCMApnsConfig where P == FCMAPNSPayload {
    /// Use this if you need only aps object
    public convenience init(headers: [String: String] = [:], aps: FCMAPNSAPSObject) {
        self.init(headers: headers, payload: FCMAPNSPayload(aps: aps))
    }
}
