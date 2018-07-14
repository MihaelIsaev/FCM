import Foundation

public struct FCMApnsConfig: Codable {
    ///HTTP request headers defined in Apple Push Notification Service. Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    ///APNs payload as a JSON object, including both aps dictionary and custom payload. See Payload Key Reference. If present, it overrides google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var payload: FCMAPNSPayload?

    /// Publically Initialize
    public init(headers: [String: String] = [:], payload: FCMAPNSPayload? = nil) {
        self.headers = headers
        self.payload = payload
    }

    enum CodingKeys: String, CodingKey {
        case headers, payload
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(headers, forKey: .headers)
        if let payload = payload {
            try container.encode(ApsWrapper(aps: payload), forKey: .payload)
        }
    }
}

// This solely exists to give the JSON nesecary as APS expects:
// apns: {
//   payload: {
//     aps: {

private struct ApsWrapper: Codable {
    let aps: FCMAPNSPayload
}
