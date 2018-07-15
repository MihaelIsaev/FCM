// This solely exists to give the JSON nesecary as APS expects:
// apns: {
//   payload: {
//     aps: {
//     }
//     CUSTOM_KEYS that will be stuck in the, so it must be open to extension

open class FCMAPNSPayload: Codable {
    /// The APS object, primary alert
    open var aps: FCMAPNSAPSObject?

    public init(aps: FCMAPNSAPSObject) {
        self.aps = aps
    }
}

// Overloading this class to include custom keys for custom actions is of nescity for doing custom actions with
// UNNotifications. An example of adding custom key to the payload is as follows

/*
public class MyAPNSPayload: FCMAPNSPayload {
    var myCustomKEY: String
    init(aps: FCMAPNSAPSObject, myCustomKEY: String) {
        self.myCustomKEY = myCustomKEY
        super.init(aps: aps)
    }
    public required init(from decoder: Decoder) throws {
        fatalError("Should never be called")
    }

    enum CodingKeys: String, CodingKey {
        case aps, myCustomKEY
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(myCustomKEY, forKey: .myCustomKEY)
        try container.encode(aps, forKey: .aps)
    }
}
*/
