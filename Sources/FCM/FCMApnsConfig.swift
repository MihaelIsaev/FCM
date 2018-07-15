import Foundation

final public class FCMApnsConfig: Codable {
    ///HTTP request headers defined in Apple Push Notification Service. Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    ///APNs payload as a JSON object, including both aps dictionary and custom payload. See Payload Key Reference. If present, it overrides google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var payload: FCMAPNSPayload?


    /// Publically Initialize
    public init(headers: [String: String] = [:], payload: FCMAPNSPayload? = nil) {
        self.headers = headers
        self.payload = payload
    }
}
