import Vapor
import Foundation
import JWT

// MARK: Engine

public struct FCM {
    let application: Application
    
    let client: HTTPClient
    
    let scope = "https://www.googleapis.com/auth/cloud-platform"
    let audience = "https://www.googleapis.com/oauth2/v4/token"
    let actionsBaseURL = "https://fcm.googleapis.com/v1/projects/"
    let iidURL = "https://iid.googleapis.com/iid/v1:"
    
    // MARK: Default configurations
    
    public var apnsDefaultConfig: FCMApnsConfig<FCMApnsPayload>? {
        get { configuration?.apnsDefaultConfig }
        set { configuration?.apnsDefaultConfig = newValue }
    }
    
    public var androidDefaultConfig: FCMAndroidConfig? {
        get { configuration?.androidDefaultConfig }
        set { configuration?.androidDefaultConfig = newValue }
    }
    
    public var webpushDefaultConfig: FCMWebpushConfig? {
        get { configuration?.webpushDefaultConfig }
        set { configuration?.webpushDefaultConfig = newValue }
    }
    
    // MARK: Initialization
    
    public init(application: Application) {
        self.application = application
        if !application.http.client.configuration.ignoreUncleanSSLShutdown {
            application.http.client.configuration.ignoreUncleanSSLShutdown = true
        }
        self.client = application.http.client.shared
    }
}

// MARK: Cache

extension FCM {
    struct ConfigurationKey: StorageKey {
        typealias Value = FCMConfiguration
    }

    public var configuration: FCMConfiguration? {
        get {
            application.storage[ConfigurationKey.self]
        }
        nonmutating set {
            application.storage[ConfigurationKey.self] = newValue
            if let newValue = newValue {
                warmUpCache(with: newValue.email)
            }
        }
    }
    
    private func warmUpCache(with email: String) {
        if gAuth == nil {
            gAuth = GAuthPayload(iss: email, sub: email, scope: scope, aud: audience)
        }
        if jwt == nil {
            do {
                jwt = try generateJWT()
            } catch {
                fatalError("FCM Unable to generate JWT: \(error)")
            }
        }
    }
    
    struct JWTKey: StorageKey {
        typealias Value = String
    }
    
    var jwt: String? {
        get {
            application.storage[JWTKey.self]
        }
        nonmutating set {
            application.storage[JWTKey.self] = newValue
        }
    }
    
    struct AccessTokenKey: StorageKey {
        typealias Value = String
    }
    
    var accessToken: String? {
        get {
            application.storage[AccessTokenKey.self]
        }
        nonmutating set {
            application.storage[AccessTokenKey.self] = newValue
        }
    }
    
    struct GAuthKey: StorageKey {
        typealias Value = GAuthPayload
    }
    
    var gAuth: GAuthPayload? {
        get {
            application.storage[GAuthKey.self]
        }
        nonmutating set {
            application.storage[GAuthKey.self] = newValue
        }
    }
}
