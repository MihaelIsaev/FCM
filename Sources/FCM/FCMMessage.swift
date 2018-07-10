import Foundation

public struct FCMMessage: Codable {
    ///Output Only. The identifier of the message sent, in the format of projects/*/messages/{message_id}.
    public var name: String
    ///Input only. Arbitrary key/value payload.
    public var data: [String: String] = [:]
    ///Input only. Basic notification template to use across all platforms.
    public var notification: Notification
    ///Input only. Android specific options for messages sent through FCM connection server.
    public var android: AndroidConfig?
    ///Input only. Webpush protocol options.
    public var webpush: WebpushConfig?
    ///Input only. Apple Push Notification Service specific options.
    public var apns: ApnsConfig?
    
    //Union field target. Required. Input only. Target to send a message to. target can be only one of the following:
    ///Registration token to send a message to.
    public var token: String?
    ///Topic name to send a message to, e.g. "weather". Note: "/topics/" prefix should not be provided.
    public var topic: String?
    ///Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
    public var condition: String?
    
    ///Initialization with device token
    public init(token: String,
                notification: Notification,
                data: [String: String]? = nil,
                name: String? = nil,
                android: AndroidConfig? = nil,
                webpush: WebpushConfig? = nil,
                apns: ApnsConfig? = nil)
    {
        self.token = token
        self.notification = notification
        if let data = data {
            self.data = data
        }
        self.name = name ?? UUID().uuidString
        self.android = android
        self.webpush = webpush
        self.apns = apns
    }
    
    ///Initialization with topic
    public init(topic: String,
                notification: Notification,
                data: [String: String]? = nil,
                name: String? = nil,
                android: AndroidConfig? = nil,
                webpush: WebpushConfig? = nil,
                apns: ApnsConfig? = nil)
    {
        self.topic = topic
        self.notification = notification
        if let data = data {
            self.data = data
        }
        self.name = name ?? UUID().uuidString
        self.android = android
        self.webpush = webpush
        self.apns = apns
    }
    
    ///Initialization with condition
    public init(condition: String,
                notification: Notification,
                data: [String: String]? = nil,
                name: String? = nil,
                android: AndroidConfig? = nil,
                webpush: WebpushConfig? = nil,
                apns: ApnsConfig? = nil)
    {
        self.condition = condition
        self.notification = notification
        if let data = data {
            self.data = data
        }
        self.name = name ?? UUID().uuidString
        self.android = android
        self.webpush = webpush
        self.apns = apns
    }
}

public struct Notification: Codable {
    ///The notification's title.
    public var title: String
    ///The notification's body text.
    public var body: String
    
    public init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}

public struct AndroidConfig: Codable {
    ///An identifier of a group of messages that can be collapsed, so that only the last message gets sent when delivery can be resumed. A maximum of 4 different collapse keys is allowed at any given time.
    public var collapse_key: String?
    ///Message priority. Can take "normal" and "high" values. For more information, see Setting the priority of a message.
    public var priority: AndroidMessagePriority
    ///How long (in seconds) the message should be kept in FCM storage if the device is offline. The maximum time to live supported is 4 weeks, and the default value is 4 weeks if not set. Set it to 0 if want to send the message immediately. In JSON format, the Duration type is encoded as a string rather than an object, where the string ends in the suffix "s" (indicating seconds) and is preceded by the number of seconds, with nanoseconds expressed as fractional seconds. For example, 3 seconds with 0 nanoseconds should be encoded in JSON format as "3s", while 3 seconds and 1 nanosecond should be expressed in JSON format as "3.000000001s". The ttl will be rounded down to the nearest second. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var ttl: String
    ///Package name of the application where the registration tokens must match in order to receive the message.
    public var restricted_package_name: String
    ///Arbitrary key/value payload. If present, it will override google.firebase.fcm.v1.Message.data.
    public var data: [String: String] = [:]
    ///Notification to send to android devices.
    public var notification: AndroidNotification
}

public enum AndroidMessagePriority: String, Codable {
    ///Default priority for data messages. Normal priority messages won't open network connections on a sleeping device, and their delivery may be delayed to conserve the battery. For less time-sensitive messages, such as notifications of new email or other data to sync, choose normal delivery priority.
    case NORMAL
    ///Default priority for notification messages. FCM attempts to deliver high priority messages immediately, allowing the FCM service to wake a sleeping device when possible and open a network connection to your app server. Apps with instant messaging, chat, or voice call alerts, for example, generally need to open a network connection and make sure FCM delivers the message to the device without delay. Set high priority if the message is time-critical and requires the user's immediate interaction, but beware that setting your messages to high priority contributes more to battery drain compared with normal priority messages.
    case HIGH
}

public struct AndroidNotification: Codable {
    ///The notification's title. If present, it will override google.firebase.fcm.v1.Notification.title.
    public var title: String
    ///The notification's body text. If present, it will override google.firebase.fcm.v1.Notification.body.
    public var body: String
    ///The notification's icon. Sets the notification icon to myicon for drawable resource myicon. If you don't send this key in the request, FCM displays the launcher icon specified in your app manifest.
    public var icon: String
    ///The notification's icon color, expressed in #rrggbb format.
    public var color: String
    ///The sound to play when the device receives the notification. Supports "default" or the filename of a sound resource bundled in the app. Sound files must reside in /res/raw/.
    public var sound: String
    ///Identifier used to replace existing notifications in the notification drawer. If not specified, each request creates a new notification. If specified and a notification with the same tag is already being shown, the new notification replaces the existing one in the notification drawer.
    public var tag: String
    ///The action associated with a user click on the notification. If specified, an activity with a matching intent filter is launched when a user clicks on the notification.
    public var click_action: String
    ///The key to the body string in the app's string resources to use to localize the body text to the user's current localization. See String Resources for more information.
    public var body_loc_key: String
    ///Variable string values to be used in place of the format specifiers in body_loc_key to use to localize the body text to the user's current localization. See Formatting and Styling for more information.
    public var body_loc_args: [String] = []
    ///The key to the title string in the app's string resources to use to localize the title text to the user's current localization. See String Resources for more information.
    public var title_loc_key: String
    ///Variable string values to be used in place of the format specifiers in title_loc_key to use to localize the title text to the user's current localization. See Formatting and Styling for more information.
    public var title_loc_args: [String] = []
}

public struct WebpushConfig: Codable {
    ///HTTP headers defined in webpush protocol. Refer to Webpush protocol for supported headers, e.g. "TTL": "15".
    public var headers: [String: String] = [:]
    ///Arbitrary key/value payload. If present, it will override google.firebase.fcm.v1.Message.data.
    public var data: [String: String] = [:]
    ///Web Notification options as a JSON object. Supports Notification instance properties as defined in Web Notification API. If present, "title" and "body" fields override google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var notification: [String: String] = [:]
}

public struct ApnsConfig: Codable {
    ///HTTP request headers defined in Apple Push Notification Service. Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    ///APNs payload as a JSON object, including both aps dictionary and custom payload. See Payload Key Reference. If present, it overrides google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var payload: [String: String] = [:]
}
