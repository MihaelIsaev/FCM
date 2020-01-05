import JWT
import Foundation

struct GAuthPayload: JWTPayload {
    let uid: String = UUID().uuidString
    
    var exp: ExpirationClaim
    var iat: IssuedAtClaim
    var iss: IssuerClaim
    var sub: SubjectClaim
    var scope: String
    var aud: AudienceClaim
    
    static var expirationClaim: ExpirationClaim {
        return ExpirationClaim(value: Date().addingTimeInterval(3600))
    }

    init(iss: String, sub: String, scope: String, aud: String) {
        self.exp = GAuthPayload.expirationClaim
        self.iat = IssuedAtClaim(value: Date())
        self.iss = IssuerClaim(value: iss)
        self.sub = SubjectClaim(value: sub)
        self.scope = scope
        self.aud = AudienceClaim(value: aud)
    }
    
    private init(iss: IssuerClaim, sub: SubjectClaim, scope: String, aud: AudienceClaim) {
        self.exp = GAuthPayload.expirationClaim
        self.iat = IssuedAtClaim(value: Date())
        self.iss = iss
        self.sub = sub
        self.scope = scope
        self.aud = aud
    }

    func verify(using signer: JWTSigner) throws {
        // not used
    }

    var hasExpired: Bool {
        do {
            try exp.verifyNotExpired()
            return false
        } catch {
            return true
        }
    }

    func updated() -> Self {
        GAuthPayload(iss: iss, sub: sub, scope: scope, aud: aud)
    }
}
