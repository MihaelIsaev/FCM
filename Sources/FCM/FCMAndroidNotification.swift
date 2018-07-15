public struct FCMAndroidNotification: Codable {
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

    /// Publically Initialize
    public init(
        title: String,
        body: String,
        icon: String,
        color: String,
        sound: String,
        tag: String,
        click_action: String,
        body_loc_key: String,
        body_loc_args: [String] = [],
        title_loc_key: String,
        title_loc_args: [String] = []
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
    }
}
