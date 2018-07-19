/// Use it for your custom payload class
///
/// Example code:
///     class MyCustomPayload: FCMApnsPayloadProtocol {
///         var aps: FCMApnsApsObject
///         var myCustomKey: String
///
///         init(aps: FCMApnsApsObject, myCustomKey: String) {
///             self.aps = aps
///             self.myCustomKey = myCustomKey
///         }
///     }
public protocol FCMApnsPayloadProtocol: Codable {
    var aps: FCMApnsApsObject { get set }
}
