import Vapor
import Foundation
import JWT
import Crypto

// MARK: Service

public protocol FCMProvider: Service {}

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
    
    // MARK: Initialization
    
    /// Key should be PEM Private key
    public init(email: String, projectId: String, pathToKey path: String) {
        self.email = email
        self.projectId = projectId
        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            fatalError("FCM pem file doesn't exists")
        }
        if let data = fm.contents(atPath: path), let key = String(data: data, encoding: .utf8) {
            self.key = key
        } else {
            fatalError("FCM unable to decode key file content")
        }
        gAuthPayload = GAuthPayload(iss: email, sub: email, scope: scope, aud: audience)
        do {
            _jwt = try generateJWT()
        } catch {
            fatalError("FCM Unable to generate JWT: \(error)")
        }
    }
}
