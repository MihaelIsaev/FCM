import Foundation
import JWT

extension FCM {
    func generateJWT() async throws -> String {
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
        let pk = try Insecure.RSA.PrivateKey(pem: pemData)
        let keys = await JWTKeyCollection().add(rsa: pk, digestAlgorithm: .sha256)
        return try await keys.sign(gAuth)
    }
    
    func getJWT() async throws -> String {
        guard let gAuth = gAuth else { fatalError("FCM gAuth can't be nil") }
        if !gAuth.hasExpired, let jwt = jwt {
            return jwt
        }
        let jwt = try await generateJWT()
        self.jwt = jwt
        return jwt
    }
}
