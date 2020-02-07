// The following struct is based on
// https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification
public struct FCMApnsApsObject: Codable, Equatable {
    /// The information for displaying an alert.
    /// A dictionary is recommended.
    /// If you specify a string, the alert displays your string as the body text.
    public var alert: FCMApnsAlertOrString?
    
    /// The number to display in a badge on your app’s icon. Specify 0 to remove the current badge, if any.
    public var badge: Int?
    
    /// The name of a sound file in your app’s main bundle
    /// or in the Library/Sounds folder of your app’s container directory.
    /// Specify the string "default" to play the system sound.
    /// Use this key for regular notifications.
    /// For critical alerts, use the sound dictionary instead.
    /// For information about how to prepare sounds, see UNNotificationSound.
    /// UNNotificationSound: https://developer.apple.com/documentation/usernotifications/unnotificationsound
    public var sound: String? // NOTE: Advanced Sounds are not implemented yet
    
    /// An app-specific identifier for grouping related notifications.
    /// This value corresponds to the threadIdentifier property in the UNNotificationContent object.
    public var threadId: String?
    
    /// The notification’s type.
    /// This string must correspond to the identifier
    /// of one of the UNNotificationCategory objects you register at launch time.
    public var category: String?

    /// Sets the priority of the message
    /// Valid values are "normal" and "high." On iOS, these correspond to APNs priorities 5 and 10.
    /// For information about how to prepare sounds, see priority.
    /// priority: https://firebase.google.com/docs/cloud-messaging/http-server-ref
    public var priority: String?
    
    /// The background notification flag.
    /// To perform a silent background update,
    /// specify the value 1
    /// and don't include the alert, badge, or sound keys in your payload.
    public var contentAvailable: Int?
    
    /// The notification service app extension flag.
    /// If the value is 1, the system passes the notification to your notification service app extension before delivery.
    /// Use your extension to modify the notification’s content.
    public var mutableContent: Int?

    enum Priority: String {
        case normal
        case high
    }

    enum CodingKeys: String, CodingKey {
        case alert
        case badge
        case sound
        case priority
        case contentAvailable = "content-available"
        case category
        case threadId="thread-id"
        case mutableContent="mutable-content"
    }

    struct Config {
        var alert: FCMApnsAlertOrString?
        var badge: Int?
        var sound: String?
        var priority: String?
        var contentAvailable: Bool?
        var category: String?
        var threadId: String?
        var mutableContent: Bool?
    }

    init(config: Config?) {
        let contentAvailable = config?.contentAvailable ?? false
        if !contentAvailable {
            alert = config?.alert
            badge = config?.badge
            sound = config?.sound
        }
        if let value = config?.priority {
            priority = value
        }
        if contentAvailable {
            self.contentAvailable = 1
        }
        category = config?.category
        threadId = config?.threadId
        if let value = config?.mutableContent, value {
            mutableContent = 1
        }
    }
    
    public static var `default`: FCMApnsApsObject {
        return FCMApnsApsObject(alertString: nil, sound: "default")
    }
    
    public init(alertString: String?,
                badge: Int? = nil,
                sound: String?,
                priority: String? = nil,
                contentAvailable: Bool? = nil,
                category: String? = nil,
                threadId: String? = nil,
                mutableContent: Bool? = nil) {
        self.init(config: Config(alert: FCMApnsAlertOrString.fromRaw(alertString),
                                 badge: badge,
                                 sound: sound,
                                 priority: priority,
                                 contentAvailable: contentAvailable,
                                 category: category,
                                 threadId: threadId,
                                 mutableContent: mutableContent))
    }
    
    public init(alert: FCMApnsAlert? = nil,
                badge: Int? = nil,
                sound: String?,
                priority: String? = nil,
                contentAvailable: Bool? = nil,
                category: String? = nil,
                threadId: String? = nil,
                mutableContent: Bool? = nil) {
        self.init(config: Config(alert: FCMApnsAlertOrString.fromRaw(alert),
                                 badge: badge,
                                 sound: sound,
                                 priority: priority,
                                 contentAvailable: contentAvailable,
                                 category: category,
                                 threadId: threadId,
                                 mutableContent: mutableContent))
    }
}

