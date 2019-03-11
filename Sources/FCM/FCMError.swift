public struct GoogleError: Error, Decodable {
    public let code: Int
    public let message: String
    public let status: String
    public let fcmError: FCMError?

    private enum TopLevelCodingKeys: String, CodingKey {
        case error
    }

    private enum CodingKeys: String, CodingKey {
        case code, message, status, details
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelCodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .error)

        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        status = try container.decode(String.self, forKey: .status)

        var details = try container.nestedUnkeyedContainer(forKey: .details)
        fcmError = try? details.decode(FCMError.self)
    }
}

public struct FCMError: Error, Decodable {
    public let errorCode: ErrorCode

    public enum ErrorCode: String, Decodable {
        case unspecified = "UNSPECIFIED_ERROR"
        case invalid = "INVALID_ARGUMENT"
        case unregistered = "UNREGISTERED"
        case senderIDMismatch = "SENDER_ID_MISMATCH"
        case quotaExceeded = "QUOTA_EXCEEDED"
        case apnsAuth = "APNS_AUTH_ERROR"
        case unavailable = "UNAVAILABLE"
        case `internal` = "INTERNAL"
    }
}
