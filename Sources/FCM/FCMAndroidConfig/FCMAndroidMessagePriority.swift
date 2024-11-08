public enum FCMAndroidMessagePriority: String, Sendable, Codable, Equatable {
    /// Default priority for data messages.
    /// Normal priority messages won't open network connections on a sleeping device,
    /// and their delivery may be delayed to conserve the battery.
    /// For less time-sensitive messages, such as notifications of new email or other data to sync, choose normal delivery priority.
    case normal = "NORMAL"
    
    /// Default priority for notification messages.
    /// FCM attempts to deliver high priority messages immediately,
    /// allowing the FCM service to wake a sleeping device when possible and open a network connection to your app server.
    /// Apps with instant messaging, chat, or voice call alerts,
    /// for example, generally need to open a network connection and make sure FCM delivers the message to the device without delay.
    /// Set high priority if the message is time-critical and requires the user's immediate interaction,
    /// but beware that setting your messages to high priority contributes more to battery drain compared with normal priority messages.
    case high = "HIGH"
}
