import Foundation

public struct FCMApnsConfig: Codable {
    ///HTTP request headers defined in Apple Push Notification Service. Refer to APNs request headers for supported headers, e.g. "apns-priority": "10".
    public var headers: [String: String] = [:]
    ///APNs payload as a JSON object, including both aps dictionary and custom payload. See Payload Key Reference. If present, it overrides google.firebase.fcm.v1.Notification.title and google.firebase.fcm.v1.Notification.body.
    public var payload: APNSPayload = .null

    /// Publically Initialize
    public init(headers: [String: String] = [:], payload: APNSPayload = .null) {
        self.headers = headers
        self.payload = payload
    }
}


public enum APNSPayload: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .floatingPointValue(double)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let array = try? container.decode([APNSPayload].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: APNSPayload].self) {
            self = .dictionary(dictionary)
        } else {
            self = .null
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(value):
            try container.encode(value)
        case let .int(value):
            try container.encode(value)
        case let .floatingPointValue(value):
            try container.encode(value)
        case let .date(value):
            try container.encode(value)
        case let .dictionary(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }

    case string(String)
    case int(Int)
    case floatingPointValue(Double)
    case date(Date)
    case array([APNSPayload])
    case dictionary([String: APNSPayload])
    case null
}
