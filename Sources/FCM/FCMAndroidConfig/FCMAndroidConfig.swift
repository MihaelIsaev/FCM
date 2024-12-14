public struct FCMAndroidConfig: Sendable, Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case collapseKey = "collapse_key"
        case priority
        case ttl
        case restrictedPackageName = "restricted_package_name"
        case data
        case notification
    }
    
    /// An identifier of a group of messages that can be collapsed, so that only the last message gets sent when delivery can be resumed.
    /// A maximum of 4 different collapse keys is allowed at any given time.
    public var collapseKey: String?
    
    /// Message priority. Can take "normal" and "high" values.
    /// For more information, see Setting the priority of a message.
    public var priority: FCMAndroidMessagePriority
    
    /// How long (in seconds) the message should be kept in FCM storage if the device is offline.
    /// The maximum time to live supported is 4 weeks, and the default value is 4 weeks if not set.
    /// Set it to 0 if want to send the message immediately.
    /// In JSON format, the Duration type is encoded as a string rather than an object,
    /// where the string ends in the suffix "s" (indicating seconds) and is preceded by the number of seconds,
    /// with nanoseconds expressed as fractional seconds.
    /// For example, 3 seconds with 0 nanoseconds should be encoded in JSON format as "3s",
    /// while 3 seconds and 1 nanosecond should be expressed in JSON format as "3.000000001s".
    /// The ttl will be rounded down to the nearest second.
    /// A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var ttl: String?
    
    /// Package name of the application where the registration tokens must match in order to receive the message.
    public var restrictedPackageName: String?
    
    /// Arbitrary key/value payload.
    /// If present, it will override FCMMessage.data.
    public var data: [String: String]?
    
    /// Notification to send to android devices.
    public var notification: FCMAndroidNotification?

    /// Public Initializer
    public init(
        collapseKey: String? = nil,
        priority: FCMAndroidMessagePriority,
        ttl: String? = nil,
        restrictedPackageName: String? = nil,
        data: [String : String]? = nil,
        notification: FCMAndroidNotification? = nil
    ) {
        self.collapseKey = collapseKey
        self.priority = priority
        self.ttl = ttl
        self.restrictedPackageName = restrictedPackageName
        self.data = data
        self.notification = notification
    }
}
