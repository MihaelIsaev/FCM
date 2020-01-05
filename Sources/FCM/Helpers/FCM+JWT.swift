import Foundation
import JWT

extension FCM {
    func generateJWT() throws -> String {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        guard var gAuth = gAuth else {
            fatalError("FCM gAuth can't be nil")
        }
        guard let pemData = configuration.key.data(using: .utf8) else {
            fatalError("FCM unable to prepare PEM data for JWT")
        }
        gAuth = gAuth.updated()
        self.gAuth = gAuth
        let pk = try RSAKey.private(pem: pemData)
        let signer = JWTSigner.rs256(key: pk)
        return try signer.sign(gAuth)
    }
    
    func getJWT() throws -> String {
        guard let gAuth = gAuth else { fatalError("FCM gAuth can't be nil") }
        if !gAuth.hasExpired, let jwt = jwt {
            return jwt
        }
        let jwt = try generateJWT()
        self.jwt = jwt
        return jwt
    }
}
