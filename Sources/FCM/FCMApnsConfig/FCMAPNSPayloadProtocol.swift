/// Use it for your custom payload class
///
/// Example code:
///     class MyCustomPayload: FCMAPNSPayloadProtocol {
///         var aps: FCMAPNSAPSObject
///         var myCustomKey: String
///
///         init(aps: FCMAPNSAPSObject, myCustomKey: String) {
///             self.aps = aps
///             self.myCustomKey = myCustomKey
///         }
///     }
public protocol FCMAPNSPayloadProtocol: Codable {
    var aps: FCMAPNSAPSObject { get set }
}
