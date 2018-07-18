/// Default APNS payload class
/// it contains aps dictionary inside
/// you can use your own custom payload class
/// it just should conform to FCMAPNSPayloadProtocol
public class FCMAPNSPayload: FCMAPNSPayloadProtocol {
    /// The APS object, primary alert
    public var aps: FCMAPNSAPSObject

    public init(aps: FCMAPNSAPSObject) {
        self.aps = aps
    }
}
