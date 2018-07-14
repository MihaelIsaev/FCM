public struct FCMApnsConfig: Codable {
    ///HTTP request headers defined in Apple Push Notification Service. Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    ///APNs payload as a JSON object, including both aps dictionary and custom payload. See Payload Key Reference. If present, it overrides google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var payload: [String: String] = [:]

    /// Publically Initialize
    public init(headers: [String: String] = [:], payload: [String: String]  = [:]) {
        self.headers = headers
        self.payload = payload
    }
}
