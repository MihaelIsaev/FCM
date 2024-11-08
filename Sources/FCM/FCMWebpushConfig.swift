public struct FCMWebpushConfig: Sendable, Codable {
    /// HTTP headers defined in webpush protocol.
    /// Refer to Webpush protocol for supported headers, e.g. "TTL": "15".
    public var headers: [String: String]?
    
    /// Arbitrary key/value payload.
    /// If present, it will override FCMMessage.data.
    public var data: [String: String]?
    
    /// Web Notification options as a JSON object.
    /// Supports Notification instance properties as defined in Web Notification API.
    /// If present, "title" and "body" fields override FCMNotification.title and FCMNotification.body.
    public var notification: [String: String]?
    
    public init (headers: [String: String]? = nil, data: [String: String]? = nil, notification: [String: String]? = nil) {
        self.headers = headers
        self.data = data
        self.notification = notification
    }
}
