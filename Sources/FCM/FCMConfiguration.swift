import Foundation
import Vapor

public struct FCMConfiguration {
    let email, projectId, key: String
    let serverKey, senderId: String?

    // MARK: -  Default configurations

    public var apnsDefaultConfig: FCMApnsConfig<FCMApnsPayload>?
    public var androidDefaultConfig: FCMAndroidConfig?
    public var webpushDefaultConfig: FCMWebpushConfig?

    // MARK: - Initializers

    public init(email: String, projectId: String, key: String, serverKey: String?, senderId: String?) {
        self.email = email
        self.projectId = projectId
        self.key = key
        self.serverKey = serverKey
        self.senderId = senderId
    }

    public init(email: String, projectId: String, keyPath: String, serverKey: String? = nil, senderId: String? = nil) {
        self.email = email
        self.projectId = projectId
        key = Self.readKey(from: keyPath)
        self.serverKey = serverKey
        self.senderId = senderId
    }

    public init(pathToServiceAccountKey path: String) {
        let s = Self.readServiceAccount(at: path)
        email = s.client_email
        projectId = s.project_id
        key = s.private_key
        serverKey = s.server_key
        senderId = s.sender_id
    }

    public init(fromJSON json: String) {
        let s = Self.parseServiceAccount(from: json)
        email = s.client_email
        projectId = s.project_id
        key = s.private_key
        serverKey = s.server_key
        senderId = s.sender_id
    }
}

// MARK: - Factories

extension FCMConfiguration {
    // MARK: - Static ENV constants lookup

    // In order to support multiple client instances,
    // is necessary to differentiate env keys lookup.
    // FORMAT: FCM_EMAIL_INSTANCE_A
    // DEFAULT: FCM_EMAIL

    enum EnvironmentKeys: String, RawRepresentable {
        case email = "FCM_EMAIL"
        case projectId = "FCM_PROJECT_ID"
        case keyPath = "FCM_KEY_PATH"
        case serverKey = "FCM_SERVER_KEY"
        case senderId = "FCM_SENDER_ID"
        case rawPrivateKey = "FCM_PRIVATE_KEY"
        case serviceAccountKeyPath = "FCM_SERVICE_ACCOUNT_KEY_PATH"
        case serviceAccountKey = "FCM_SERVICE_ACCOUNT_KEY"

        func lookup(for id: FCM.ID) -> String? {
            if id == .default {
                Environment.get(rawValue)
            } else {
                Environment.get(rawValue + "_" + id.rawValue)
            }
        }
    }

    // MARK: Static initializers

    /// It will try to read
    /// - FCM_EMAIL
    /// - FCM_PROJECT_ID
    /// - FCM_KEY_PATH
    /// and optionally
    /// - FCM_SERVER_KEY
    /// - FCM_SENDER_ID
    /// credentials from environment variables based on instance
    public static func envCredentials(for id: FCM.ID = .default) -> FCMConfiguration {
        guard
            let email = EnvironmentKeys.email.lookup(for: id),
            let projectId = EnvironmentKeys.projectId.lookup(for: id),
            let keyPath = EnvironmentKeys.keyPath.lookup(for: id)
        else {
            fatalError("FCM envCredentials for: \(id.rawValue) not set")
        }

        let serverKey = EnvironmentKeys.serverKey.lookup(for: id)
        let senderId = EnvironmentKeys.senderId.lookup(for: id)
        return .init(email: email, projectId: projectId, keyPath: keyPath, serverKey: serverKey, senderId: senderId)
    }

    /// It will try to read path to service account key from environment variables
    public static func envServiceAccountKey(for id: FCM.ID = .default) -> FCMConfiguration {
        if let path = EnvironmentKeys.serviceAccountKeyPath.lookup(for: id) {
            return .init(pathToServiceAccountKey: path)
        } else if let jsonString = EnvironmentKeys.serviceAccountKey.lookup(for: id) {
            return .init(fromJSON: jsonString)
        } else { fatalError("FCM envServiceAccountKey not set") }
    }

    /// It will try to read
    /// - FCM_EMAIL - client_email
    /// - FCM_PROJECT_ID - project_id
    /// - FCM_PRIVATE_KEY - private_key
    /// credentials from environment variables based on instance
    public static func envServiceAccountKeyFields(for id: FCM.ID = .default) -> FCMConfiguration {
        guard
            let email = EnvironmentKeys.email.lookup(for: id),
            let projectId = EnvironmentKeys.projectId.lookup(for: id),
            let rawPrivateKey = EnvironmentKeys.rawPrivateKey.lookup(for: id)
        else {
            fatalError("FCM envCredentials not set")
        }

        return .init(
            email: email,
            projectId: projectId,
            key: rawPrivateKey.replacingOccurrences(of: "\\n", with: "\n"),
            serverKey: nil,
            senderId: nil
        )
    }

    // MARK: Helpers

    private static func readKey(from path: String) -> String {
        let fm = FileManager.default
        guard let data = fm.contents(atPath: path) else {
            fatalError("FCM pem key file doesn't exists")
        }
        guard let key = String(data: data, encoding: .utf8) else {
            fatalError("FCM unable to decode key file content")
        }
        return key
    }

    private struct ServiceAccount: Decodable {
        let project_id, private_key, client_email: String
        let server_key, sender_id: String?
    }

    private static func readServiceAccount(at path: String) -> ServiceAccount {
        let fm = FileManager.default
        guard let data = fm.contents(atPath: path) else {
            fatalError("FCM serviceAccount file doesn't exists at path: \(path)")
        }
        guard let serviceAccount = try? JSONDecoder().decode(ServiceAccount.self, from: data) else {
            fatalError("FCM unable to decode serviceAccount from file located at: \(path)")
        }
        return serviceAccount
    }

    private static func parseServiceAccount(from json: String) -> ServiceAccount {
        guard let data = json.data(using: .utf8), let serviceAccount = try? JSONDecoder().decode(ServiceAccount.self, from: data) else {
            fatalError("FCM unable to decode serviceAccount from json string: \(json)")
        }
        return serviceAccount
    }
}
