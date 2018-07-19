/// Default APNS payload class
/// it contains aps dictionary inside
/// you can use your own custom payload class
/// it just should conform to FCMApnsPayloadProtocol
public class FCMApnsPayload: FCMApnsPayloadProtocol {
    /// The APS object, primary alert
    public var aps: FCMApnsApsObject

    public init(aps: FCMApnsApsObject? = nil) {
        self.aps = aps ?? FCMApnsApsObject.default
    }
}
