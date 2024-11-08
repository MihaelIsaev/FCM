/// Use it for your custom payload model
///
/// Example code:
/// ```swift
/// struct MyCustomPayload: FCMApnsPayloadProtocol {
///     var aps: FCMApnsApsObject
///     var myCustomKey: String
///
///     init(aps: FCMApnsApsObject, myCustomKey: String) {
///         self.aps = aps
///         self.myCustomKey = myCustomKey
///     }
/// }
/// ```
public protocol FCMApnsPayloadProtocol: Sendable, Codable, Equatable {
    var aps: FCMApnsApsObject { get set }
}
