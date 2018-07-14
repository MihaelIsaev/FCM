// The following struct is based on
// https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification
public struct FCMAPNSPayload: Codable {
    /// The information for displaying an alert. A dictionary is recommended. If you specify a string, the alert displays your string as the body text.
    var alert: FCMAPNSAlertOrString?
    /// The number to display in a badge on your app’s icon. Specify 0 to remove the current badge, if any.
    var badge: Int?
    /// The name of a sound file in your app’s main bundle or in the Library/Sounds folder of your app’s container directory. Specify the string "default" to play the system sound. Use this key for regular notifications. For critical alerts, use the sound dictionary instead. For information about how to prepare sounds, see UNNotificationSound.
    /// UNNotificationSound: https://developer.apple.com/documentation/usernotifications/unnotificationsound
    var sound: String? // NOTE: Advanced Sounds are not implemented yet
    /// An app-specific identifier for grouping related notifications. This value corresponds to the threadIdentifier property in the UNNotificationContent object.
    var threadId: String?
    /// The notification’s type. This string must correspond to the identifier of one of the UNNotificationCategory objects you register at launch time.
    var category: String?
    /// The background notification flag. To perform a silent background update, specify the value 1 and don't include the alert, badge, or sound keys in your payload.
    var contentAvailable: Int?
    /// The notification service app extension flag. If the value is 1, the system passes the notification to your notification service app extension before delivery. Use your extension to modify the notification’s content.
    var mutableContent: Int?

    enum CodingKeys: String, CodingKey {
        case alert
        case badge
        case sound
        case contentAvailable = "content-available"
        case category
        case threadId="thread-id"
        case mutableContent="mutable-content"
    }

    public init(
        alert: FCMAPNSAlertOrString? = nil,
        badge: Int? = nil,
        sound: String? = nil,
        contentAvailable: Int? = nil,
        category: String? = nil,
        threadId: String? = nil,
        mutableContent: Int? = nil
        ) {
        self.alert = alert
        self.badge = badge
        self.sound = sound
        self.contentAvailable = contentAvailable
        self.category = category
        self.threadId = threadId
        self.mutableContent = mutableContent
    }
}

