public struct FCMAPNSAlert: Codable {
    /// The title of the notification.
    /// Apple Watch displays this string in the short look notification interface.
    /// Specify a string that is quickly understood by the user.
    var title: String?
    /// Additional information that explains the purpose of the notification.
    var subtitle: String?
    /// The content of the alert message.
    var body: String?
    /// The name of the launch image file to display.
    /// If the user chooses to launch your app,
    /// the contents of the specified image or storyboard file are displayed instead of your app's normal launch image.
    var launchImage: String?
    /// The key for a localized title string.
    /// Specify this key instead of the title key to retrieve the title from your app’s Localizable.strings files.
    /// The value must contain the name of a key in your strings file.
    var titleLocKey: String?
    /// An array of strings containing replacement values for variables in your title string.
    /// Each %@ character in the string specified by the title-loc-key is replaced by a value from this array.
    /// The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on.
    var titleLocArgs: [String]?
    /// The key for a localized subtitle string.
    /// Use this key, instead of the subtitle key, to retrieve the subtitle from your app's Localizable.strings file.
    /// The value must contain the name of a key in your strings file.
    var subtitleLocKey: String?
    /// An array of strings containing replacement values for variables in your title string.
    /// Each %@ character in the string specified by subtitle-loc-key is replaced by a value from this array.
    /// The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on.
    var subtitleLocArgs: [String]?
    ///A key to an alert-message string in a Localizable.strings file for the current localization (which is set by the user’s language preference).
    /// The key string can be formatted with %@ and %n$@ specifiers to take the variables specified in the loc-args array.
    /// See Localizing the Content of Your Remote Notifications for more information.
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

    public init(title: String? = nil,
                subtitle: String? = nil,
                body: String? = nil,
                titleLocKey: String? = nil,
                titleLocArgs: [String]? = nil,
                subtitleLocKey: String? = nil,
                subtitleLocArgs: [String]? = nil,
                locKey: String? = nil,
                locArgs: [String]? = nil,
                launchImage: String? = nil) {
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
