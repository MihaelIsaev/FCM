import Foundation
import Crypto
import JWT

extension FCM {
    func generateJWT() throws -> String {
        gAuthPayload.update()
        let pk = try RSAKey.private(pem: key)
        let signer = JWTSigner.rs256(key: pk)
        let jwt = JWT<GAuthPayload>(payload: gAuthPayload)
        let jwtData = try jwt.sign(using: signer)
        return String(data: jwtData, encoding: .utf8)!
    }
    
    func getJWT() throws -> String {
        if !gAuthPayload.hasExpired {
            return _jwt
        }
        _jwt = try generateJWT()
        return _jwt
    }
}
