/// Internal helper for different alert payload types
enum FCMApnsAlertOrString: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            let alert = try container.decode(FCMApnsAlert.self)
            self = .alert(alert)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .alert(alert):
            try container.encode(alert)
        case let .string(string):
            try container.encode(string)
        }
    }
    
    static func fromRaw(_ v: FCMApnsAlert?) -> FCMApnsAlertOrString? {
        guard let v = v else { return nil }
        return .alert(v)
    }
    
    static func fromRaw(_ v: String?) -> FCMApnsAlertOrString? {
        guard let v = v else { return nil }
        return .string(v)
    }

    /// A container for alerts
    case alert(FCMApnsAlert)
    /// A container for strings
    case string(String)
}
