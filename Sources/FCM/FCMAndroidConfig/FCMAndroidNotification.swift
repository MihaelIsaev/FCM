public struct FCMAndroidNotification: Sendable, Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case icon
        case color
        case sound
        case tag
        case clickAction = "click_action"
        case bodyLocalizationKey = "body_loc_key"
        case bodyLocalizationArgs = "body_loc_args"
        case titleLocalizationKey = "title_loc_key"
        case titleLocalizationArgs = "title_loc_args"
        case channelID = "channel_id"
        case ticker
        case sticky
        case eventTime = "event_time"
        case localOnly = "local_only"
        case notificationPriority = "notification_priority"
        case defaultSound = "default_sound"
        case defaultVibrateTimings = "default_vibrate_timings"
        case defaultLightSettings = "default_light_settings"
        case vibrateTimings = "vibrate_timings"
        case visibility
        case notificationCount = "notification_count"
        case lightSettings = "light_settings"
        case image
    }
    
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
    public var clickAction: String?
    
    /// The key to the body string in the app's string resources
    /// to use to localize the body text to the user's current localization.
    /// See String Resources for more information.
    public var bodyLocalizationKey: String?
    
    /// Variable string values to be used in place of the format specifiers
    /// in body_loc_key to use to localize the body text to the user's current localization.
    /// See Formatting and Styling for more information.
    public var bodyLocalizationArgs: [String]?
    
    /// The key to the title string in the app's string resources
    /// to use to localize the title text to the user's current localization.
    /// See String Resources for more information.
    public var titleLocalizationKey: String?
    
    /// Variable string values to be used in place of the format specifiers
    /// in title_loc_key to use to localize the title text to the user's current localization.
    /// See Formatting and Styling for more information.
    public var titleLocalizationArgs: [String]?

    /// The notification's channel id (new in Android O).
    /// The app must create a channel with this channel ID before any notification with this channel ID is received.
    /// If you don't send this channel ID in the request, or if the channel ID provided has not yet been created by the app,
    /// FCM uses the channel ID specified in the app manifest.
    public var channelID: String?

    /// Sets the "ticker" text, which is sent to accessibility services.
    /// Prior to API level 21 (Lollipop), sets the text that is displayed in the status bar when the notification first arrives.
    public var ticker: String?

    /// When set to false or unset, the notification is automatically dismissed when the user clicks it in the panel.
    /// When set to true, the notification persists even when the user clicks it.
    public var sticky: Bool?

    /// Set the time that the event in the notification occurred. Notifications in the panel are sorted by this time.
    /// A point in time is represented using protobuf.Timestamp.
    /// A timestamp in RFC3339 UTC "Zulu" format, accurate to nanoseconds.
    /// Example: "2014-10-02T15:01:23.045123456Z".
    public var eventTime: String?

    /// Set whether or not this notification is relevant only to the current device.
    /// Some notifications can be bridged to other devices for remote display, such as a Wear OS watch.
    /// This hint can be set to recommend this notification not be bridged. See Wear OS guides
    public var localOnly: Bool?

    /// Set the relative priority for this notification.
    /// Priority is an indication of how much of the user's attention should be consumed by this notification.
    /// Low-priority notifications may be hidden from the user in certain situations, while the user might be interrupted for a higher-priority notification.
    /// The effect of setting the same priorities may differ slightly on different platforms.
    /// Note this priority differs from AndroidMessagePriority.
    /// This priority is processed by the client after the message has been delivered,
    /// whereas AndroidMessagePriority is an FCM concept that controls when the message is delivered.
    public var notificationPriority: FCMAndroidNotificationPriority?

    /// If set to true, use the Android framework's default sound for the notification.
    /// Default values are specified in config.xml.
    public var defaultSound: Bool?

    /// If set to true, use the Android framework's default vibrate pattern for the notification.
    /// Default values are specified in config.xml.
    /// If default_vibrate_timings is set to true and vibrate_timings is also set,
    /// the default value is used instead of the user-specified vibrate_timings.
    public var defaultVibrateTimings: Bool?

    /// If set to true, use the Android framework's default LED light settings for the notification.
    /// Default values are specified in config.xml.
    /// If default_light_settings is set to true and light_settings is also set,
    /// the user-specified light_settings is used instead of the default value.
    public var defaultLightSettings: Bool?

    /// Set the vibration pattern to use.
    /// Pass in an array of protobuf.Duration to turn on or off the vibrator.
    /// The first value indicates the Duration to wait before turning the vibrator on.
    /// The next value indicates the Duration to keep the vibrator on.
    /// Subsequent values alternate between Duration to turn the vibrator off and to turn the vibrator on.
    /// If vibrate_timings is set and default_vibrate_timings is set to true,
    /// the default value is used instead of the user-specified vibrate_timings.
    /// A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var vibrateTimings: [String]?

    /// Set the Notification.visibility of the notification.
    public var visibility: FCMAndroidNotificationVisibility?

    /// Sets the number of items this notification represents.
    /// May be displayed as a badge count for launchers that support badging.See Notification Badge.
    /// For example, this might be useful if you're using just one notification to represent multiple new messages
    /// but you want the count here to represent the number of total new messages.
    /// If zero or unspecified, systems that support badging use the default,
    /// which is to increment a number displayed on the long-press menu each time a new notification arrives.
    public var notificationCount: Int?

    /// Settings to control the notification's LED blinking rate and color if LED is available on the device.
    /// The total blinking time is controlled by the OS.
    public var lightSettings: FCMAndroidNotificationLightSettings?

    /// Contains the URL of an image that is going to be displayed in a notification.
    /// If present, it will override google.firebase.fcm.v1.Notification.image.
    public var image: String?
    
    init(
        title: String? = nil,
        body: String? = nil,
        icon: String? = nil,
        color: String? = nil,
        sound: String? = nil,
        tag: String? = nil,
        clickAction: String? = nil,
        bodyLocalizationKey: String? = nil,
        bodyLocalizationArgs: [String]? = nil,
        titleLocalizationKey: String? = nil,
        titleLocalizationArgs: [String]? = nil,
        channelID: String? = nil,
        ticker: String? = nil,
        sticky: Bool? = nil,
        eventTime: String? = nil,
        localOnly: Bool? = nil,
        notificationPriority: FCMAndroidNotificationPriority? = nil,
        defaultSound: Bool? = nil,
        defaultVibrateTimings: Bool? = nil,
        defaultLightSettings: Bool? = nil,
        vibrateTimings: [String]? = nil,
        visibility: FCMAndroidNotificationVisibility? = nil,
        notificationCount: Int? = nil,
        lightSettings: FCMAndroidNotificationLightSettings? = nil,
        image: String? = nil
    ) {
        self.title = title
        self.body = body
        self.icon = icon
        self.color = color
        self.sound = sound
        self.tag = tag
        self.clickAction = clickAction
        self.bodyLocalizationKey = bodyLocalizationKey
        self.bodyLocalizationArgs = bodyLocalizationArgs
        self.titleLocalizationKey = titleLocalizationKey
        self.titleLocalizationArgs = titleLocalizationArgs
        self.channelID = channelID
        self.ticker = ticker
        self.sticky = sticky
        self.eventTime = eventTime
        self.localOnly = localOnly
        self.notificationPriority = notificationPriority
        self.defaultSound = defaultSound
        self.defaultVibrateTimings = defaultVibrateTimings
        self.defaultLightSettings = defaultLightSettings
        self.vibrateTimings = vibrateTimings
        self.visibility = visibility
        self.notificationCount = notificationCount
        self.lightSettings = lightSettings
        self.image = image
    }
}
