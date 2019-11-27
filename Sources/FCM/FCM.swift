import Vapor
import Foundation
import JWT
import Crypto

// MARK: Service

public protocol FCMProvider: Service {
    func sendMessage(_ client: Client, message: FCMMessageDefault) throws -> Future<String>
}

// MARK: Engine

public class FCM: FCMProvider {
    let email: String
    let key: String
    let projectId: String
    
    let scope = "https://www.googleapis.com/auth/cloud-platform"
    let audience = "https://www.googleapis.com/oauth2/v4/token"
    let actionsBaseURL = "https://fcm.googleapis.com/v1/projects/"
    
    let gAuthPayload: GAuthPayload
    var _jwt: String = ""
    var accessToken: String?
    
    // MARK: Default configurations
    
    public var apnsDefaultConfig: FCMApnsConfig<FCMApnsPayload>?
    public var androidDefaultConfig: FCMAndroidConfig?
    public var webpushDefaultConfig: FCMWebpushConfig?
    
    // MARK: Initialization
    
    /// Key should be PEM Private key
    public init(email: String, projectId: String, key: String) {
        self.email = email
        self.projectId = projectId
        self.key = key
        gAuthPayload = GAuthPayload(iss: email, sub: email, scope: scope, aud: audience)
        do {
            _jwt = try generateJWT()
        } catch {
            fatalError("FCM Unable to generate JWT: \(error)")
        }
    }
}
