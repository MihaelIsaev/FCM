public struct FCMNotification: Codable {
    ///The notification's title.
    public var title: String
    ///The notification's body text.
    public var body: String
    
    public init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
