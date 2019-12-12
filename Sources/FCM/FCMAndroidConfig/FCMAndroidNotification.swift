import Foundation

public enum FCMAndroidNotificationPriority: String, Codable, Equatable {

    case unspecified = "PRIORITY_UNSPECIFIED"
    case min         = "PRIORITY_MIN"
    case low         = "PRIORITY_LOW"
    case `default`   = "PRIORITY_DEFAULT"
    case high        = "PRIORITY_HIGH"
    case max         = "PRIORITY_MAX"
}

public enum FCMAndroidVisibility: String, Codable, Equatable {

    case unspecified = "VISIBILITY_UNSPECIFIED"
    case `private`   = "PRIVATE"
    case `public`    = "PUBLIC"
    case secret      = "SECRET"
}

public struct FCMAndroidNotification: Codable, Equatable {

    /// The notification's title.
    /// If present, it will override FCMNotification.title.
    public var title: String?
    
    /// The notification's body text.
    /// If present, it will override FCMNotification.body.
    public var body: String?

    /// The notification's icon. Sets the notification icon to myicon for drawable resource myicon.
    /// If you don't send this key in the request,
    /// FCM displays the launcher icon specified in your app manifest.
    public var icon: String?
    
    /// The notification's icon color, expressed in #rrggbb format.
    public var color: String?
    
    /// The sound to play when the device receives the notification.
    /// Supports "default" or the filename of a sound resource bundled in the app. Sound files must reside in /res/raw/.
    public var sound: String?
    
    ///Identifier used to replace existing notifications in the notification drawer. If not specified, each request creates a new notification. If specified and a notification with the same tag is already being shown, the new notification replaces the existing one in the notification drawer.
    public var tag: String?
    
    /// The action associated with a user click on the notification.
    /// If specified, an activity with a matching intent filter is launched when a user clicks on the notification.
    public var click_action: String?
    
    /// The key to the body string in the app's string resources
    /// to use to localize the body text to the user's current localization.
    /// See String Resources for more information.
    public var body_loc_key: String?
    
    /// Variable string values to be used in place of the format specifiers
    /// in body_loc_key to use to localize the body text to the user's current localization.
    /// See Formatting and Styling for more information.
    public var body_loc_args: [String]?
    
    /// The key to the title string in the app's string resources
    /// to use to localize the title text to the user's current localization.
    /// See String Resources for more information.
    public var title_loc_key: String?
    
    /// Variable string values to be used in place of the format specifiers
    /// in title_loc_key to use to localize the title text to the user's current localization.
    /// See Formatting and Styling for more information.
    public var title_loc_args: [String]?

    /// The notification's channel id (new in Android O). The app must create a channel with this channel ID before any notification with this channel ID is received. If you don't send this channel ID in the request, or if the channel ID provided has not yet been created by the app, FCM uses the channel ID specified in the app manifest.
    public var channel_id: String?

    public var ticker: String?

    public var sticky: Bool?

    public var event_time: Date?

    public var local_only: Bool?

    public var notification_priority: FCMAndroidNotificationPriority?

    public var default_sound: Bool?

    public var default_vibrate_timings: Bool?

    public var default_light_settings: Bool?

    public var vibrate_timings: [String]?

    public var visibility: FCMAndroidVisibility?

    public var notification_count: Int?

//    public var channel_id: String?
    public var image: String?

    /// Public Initializer
    public init(title: String? = nil,
                body: String? = nil,
                icon: String? = nil,
                color: String? = nil,
                sound: String? = nil,
                tag: String? = nil,
                click_action: String? = nil,
                body_loc_key: String? = nil,
                body_loc_args: [String]? = nil,
                title_loc_key: String? = nil,
                title_loc_args: [String]? = nil,
                channel_id: String? = nil,
                ticker: String? = nil,
                sticky: Bool? = nil,
                event_time: Date? = nil,
                local_only: Bool? = nil,
                notification_priority: FCMAndroidNotificationPriority? = nil,
                default_sound: Bool? = nil,
                default_vibrate_timings: Bool? = nil,
                default_light_settings: Bool? = nil,
                vibrate_timings: [String]? = nil,
                visibility: FCMAndroidVisibility? = nil,
                notification_count: Int? = nil,
                image: String? = nil
    ) {
        self.title = title
        self.body = body
        self.icon = icon
        self.color = color
        self.sound = sound
        self.tag = tag
        self.click_action = click_action
        self.body_loc_key = body_loc_key
        self.body_loc_args = body_loc_args
        self.title_loc_key = title_loc_key
        self.title_loc_args = title_loc_args
        self.channel_id = channel_id
        self.ticker = ticker
        self.sticky = sticky
        self.event_time = event_time
        self.local_only = local_only
        self.notification_priority = notification_priority
        self.default_sound = default_sound
        self.default_vibrate_timings = default_vibrate_timings
        self.default_light_settings = default_light_settings
        self.vibrate_timings = vibrate_timings
        self.visibility = visibility
        self.notification_count = notification_count
        self.image = image
    }
}
