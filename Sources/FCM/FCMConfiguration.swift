import Foundation
import Vapor

public struct FCMConfiguration: Sendable {
    let email, projectId, key: String
    let serverKey, senderId: String?
    
    // MARK: Default configurations
    
    public var apnsDefaultConfig: FCMApnsConfig<FCMApnsPayload>?
    public var androidDefaultConfig: FCMAndroidConfig?
    public var webpushDefaultConfig: FCMWebpushConfig?

    // MARK: Initializers
    
    public init (email: String, projectId: String, key: String, serverKey: String? = nil, senderId: String? = nil) {
        self.email = email
        self.projectId = projectId
        self.key = key
        self.serverKey = serverKey ?? Environment.get("FCM_SERVER_KEY")
        self.senderId = senderId ?? Environment.get("FCM_SENDER_ID")
    }
    
    public init (email: String, projectId: String, keyPath: String, serverKey: String? = nil, senderId: String? = nil) {
        self.email = email
        self.projectId = projectId
        self.key = Self.readKey(from: keyPath)
        self.serverKey = serverKey ?? Environment.get("FCM_SERVER_KEY")
        self.senderId = senderId ?? Environment.get("FCM_SENDER_ID")
    }
    
    public init (pathToServiceAccountKey path: String) {
        let s = Self.readServiceAccount(at: path)
        self.email = s.client_email
        self.projectId = s.project_id
        self.key = s.private_key
        self.serverKey = s.server_key ?? Environment.get("FCM_SERVER_KEY")
        self.senderId = s.sender_id ?? Environment.get("FCM_SENDER_ID")
    }
    
    public init (fromJSON json: String) {
        let s = Self.parseServiceAccount(from: json)
        self.email = s.client_email
        self.projectId = s.project_id
        self.key = s.private_key
        self.serverKey = s.server_key ?? Environment.get("FCM_SERVER_KEY")
        self.senderId = s.sender_id ?? Environment.get("FCM_SENDER_ID")
    }
    
    // MARK: Static initializers
    
    /// It will try to read
    /// - FCM_EMAIL
    /// - FCM_PROJECT_ID
    /// - FCM_KEY_PATH
    /// credentials from environment variables
    public static var envCredentials: FCMConfiguration {
        guard
            let email = Environment.get("FCM_EMAIL"),
            let projectId = Environment.get("FCM_PROJECT_ID"),
            let keyPath = Environment.get("FCM_KEY_PATH")
        else {
            fatalError("FCM envCredentials not set")
        }
        let serverKey = Environment.get("FCM_SERVER_KEY")
        let senderId = Environment.get("FCM_SENDER_ID")
        return .init(email: email, projectId: projectId, keyPath: keyPath, serverKey: serverKey, senderId: senderId)
    }
    
    /// It will try to read path to service account key from environment variables
    public static var envServiceAccountKey: FCMConfiguration {
        if let path = Environment.get("FCM_SERVICE_ACCOUNT_KEY_PATH") {
            return .init(pathToServiceAccountKey: path)
        } else if let jsonString = Environment.get("FCM_SERVICE_ACCOUNT_KEY") {
            return .init(fromJSON: jsonString)
        } else { fatalError("FCM envServiceAccountKey not set") }
    }
    
    /// It will try to read
    /// - FCM_EMAIL - client_email
    /// - FCM_PROJECT_ID - project_id
    /// - FCM_PRIVATE_KEY - private_key
    /// credentials from environment variables
    public static var envServiceAccountKeyFields: FCMConfiguration {
        guard
            let email = Environment.get("FCM_EMAIL"),
            let projectId = Environment.get("FCM_PROJECT_ID"),
            let rawPrivateKey = Environment.get("FCM_PRIVATE_KEY")
        else {
            fatalError("FCM envCredentials not set")
        }
        return .init(email: email, projectId: projectId, key: rawPrivateKey.replacingOccurrences(of: "\\n", with: "\n"))
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
    
    private struct ServiceAccount: Codable {
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
