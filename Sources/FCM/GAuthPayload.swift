import JWT
import Foundation

class GAuthPayload: JWTPayload {
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
    
    func verify() throws {
        try exp.verify()
    }
    
    var isValid: Bool {
        do {
            try verify()
            return true
        } catch {
            return false
        }
    }
    
    func updateIfNeeded() {
        if !isValid {
            update()
        }
    }
    
    func update() {
        self.exp = GAuthPayload.expirationClaim
        self.iat = IssuedAtClaim(value: Date())
    }
}
