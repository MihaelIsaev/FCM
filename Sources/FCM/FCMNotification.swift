public struct FCMNotification: Codable {
    /// The notification's title.
    public var title: String
    
    /// The notification's body text.
    public var body: String
    
    public var badge: String?

    public var clickAction: String?
    
    public var priority: String?
    
    public enum CodingKeys: String, CodingKey {
        case title, body, badge, priority
        case clickAction = "click-action"
    }
    
    /// - parameters:
    ///     - title: The notification's title.
    ///     - body: The notification's body text.
    public init(title: String, body: String, badge: String? = nil, clickAction: String? = nil, priority: String? = "high") {
        self.title = title
        self.body = body
        self.badge = badge
        self.clickAction = clickAction
        self.priority = priority
    }
}
