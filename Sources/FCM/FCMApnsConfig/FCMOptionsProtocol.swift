public protocol FCMOptionsProtocol {
    /// Label associated with the message's analytics data.
    /// Use it for your custom payload model
    ///
    /// Example code:
    ///     struct FCMApnsOptions: FCMOptionsProtocol {
    ///         var analyticsLabel: String { get set }
    ///         var image: String { get set }
    ///         
    ///         enum CodingKeys: String, CodingKey {
    ///             case analyticsLabel = "analytics_label"
    ///             case image
    ///         }
    ///         
    ///         init(analyticsLabel: String, image: String) {
    ///             self.analyticsLabel = analyticsLabel
    ///             self.image = image
    ///         }
    ///     }
    var analyticsLabel: String { get set }
    
    /// Image URL string.
    /// Use it for your custom payload model
    ///
    /// Example code:
    ///     struct FCMApnsOptions: FCMOptionsProtocol {
    ///         var analyticsLabel: String { get set }
    ///         var image: String { get set }
    ///
    ///         enum CodingKeys: String, CodingKey {
    ///             case analyticsLabel = "analytics_label"
    ///             case image
    ///         }
    ///
    ///         init(analyticsLabel: String, image: String) {
    ///             self.analyticsLabel = analyticsLabel
    ///             self.image = image
    ///         }
    ///     }
    var image: String { get set }
}
