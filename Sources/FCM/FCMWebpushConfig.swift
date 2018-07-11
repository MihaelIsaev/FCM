public struct FCMWebpushConfig: Codable {
    ///HTTP headers defined in webpush protocol. Refer to Webpush protocol for supported headers, e.g. "TTL": "15".
    public var headers: [String: String] = [:]
    ///Arbitrary key/value payload. If present, it will override google.firebase.fcm.v1.Message.data.
    public var data: [String: String] = [:]
    ///Web Notification options as a JSON object. Supports Notification instance properties as defined in Web Notification API. If present, "title" and "body" fields override google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var notification: [String: String] = [:]
}
