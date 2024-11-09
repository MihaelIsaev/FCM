public struct FCMOptions: Sendable, Codable, Equatable, FCMOptionsProtocol {
    /// Label associated with the message's analytics data.
    public var analyticsLabel: String
    /// Image to be shown in push messages
    public var image: String

    enum CodingKeys: String, CodingKey {
        case analyticsLabel = "analytics_label"
        case image = "image"
    }

    public init(analyticsLabel: String, image: String = "") {
        self.analyticsLabel = analyticsLabel
        self.image = image
    }
}
