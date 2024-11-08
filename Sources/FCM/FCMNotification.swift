public struct FCMNotification: Sendable, Codable {
    /// The notification's title.
    var title: String
    
    /// The notification's body text.
    var body: String
    
    /// - parameters:
    ///     - title: The notification's title.
    ///     - body: The notification's body text.
    public init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
