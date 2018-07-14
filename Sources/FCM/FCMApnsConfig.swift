import Foundation

public struct FCMApnsConfig: Codable {
    ///HTTP request headers defined in Apple Push Notification Service. Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    ///APNs payload as a JSON object, including both aps dictionary and custom payload. See Payload Key Reference. If present, it overrides google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var payload: FCMAPNSPayload?

    /// Publically Initialize
    public init(headers: [String: String] = [:], payload: FCMAPNSPayload? = nil) {
        self.headers = headers
        self.payload = payload
    }
}

// The following struct is based on
// https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification
public struct FCMAPNSPayload: Codable {
    /// The information for displaying an alert. A dictionary is recommended. If you specify a string, the alert displays your string as the body text.
    var alert: APNSAlertOrString?
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
        alert: APNSAlertOrString? = nil,
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

public enum APNSAlertOrString: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            let alert = try container.decode(APNSAlert.self)
            self = .alert(alert)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let.alert(alert):
            try container.encode(alert)
        case let.string(string):
            try container.encode(string)
        }
    }

    case alert(APNSAlert)
    case string(String)
}

public struct APNSAlert: Codable {
    /// The title of the notification. Apple Watch displays this string in the short look notification interface. Specify a string that is quickly understood by the user.
    var title: String?
    /// Additional information that explains the purpose of the notification.
    var subtitle: String?
    /// The content of the alert message.
    var body: String?
    /// The name of the launch image file to display. If the user chooses to launch your app, the contents of the specified image or storyboard file are displayed instead of your app's normal launch image.
    var launchImage: String?
    /// The key for a localized title string. Specify this key instead of the title key to retrieve the title from your app’s Localizable.strings files. The value must contain the name of a key in your strings file.
    var titleLocKey: String?
    /// An array of strings containing replacement values for variables in your title string. Each %@ character in the string specified by the title-loc-key is replaced by a value from this array. The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on.
    var titleLocArgs: [String]?
    /// The key for a localized subtitle string. Use this key, instead of the subtitle key, to retrieve the subtitle from your app's Localizable.strings file. The value must contain the name of a key in your strings file.
    var subtitleLocKey: String?
    /// An array of strings containing replacement values for variables in your title string. Each %@ character in the string specified by subtitle-loc-key is replaced by a value from this array. The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on.
    var subtitleLocArgs: [String]?
    ///A key to an alert-message string in a Localizable.strings file for the current localization (which is set by the user’s language preference). The key string can be formatted with %@ and %n$@ specifiers to take the variables specified in the loc-args array. See Localizing the Content of Your Remote Notifications for more information.
    var locKey: String?
    ///Variable string values to appear in place of the format specifiers in loc-key. See Localizing the Content of Your Remote Notifications for more information.
    var locArgs: [String]?


    enum CodingKeys: String, CodingKey {
        case title
        case body
        case titleLocKey = "title-loc-key"
        case titleLocArgs = "title-loc-args"
        case locKey = "loc-key"
        case locArgs = "loc-args"
        case launchImage = "launch-image"
        case subtitleLocKey = "subtitle-loc-key"
        case subtitleLocArgs = "subtitle-loc-args"
    }

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        body: String? = nil,
        titleLocKey: String? = nil,
        titleLocArgs: [String]? = nil,
        subtitleLocKey: String? = nil,
        subtitleLocArgs: [String]? = nil,
        locKey: String? = nil,
        locArgs: [String]? = nil,
        launchImage: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.titleLocKey = titleLocKey
        self.titleLocArgs = titleLocArgs
        self.subtitleLocKey = subtitleLocKey
        self.subtitleLocArgs = subtitleLocArgs
        self.locKey = locKey
        self.locArgs = locArgs
        self.launchImage = launchImage
    }
}
