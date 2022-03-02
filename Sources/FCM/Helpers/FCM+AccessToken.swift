import Foundation
import Vapor

extension FCM {
    struct Result: Codable {
        let access_token: String
    }
    
    @discardableResult
    func getAccessToken() async throws -> String {
        guard let gAuth = gAuth else {
            fatalError("FCM gAuth can't be nil")
        }
        if !gAuth.hasExpired, let token = accessToken {
            return token
        }
        let response = try await client.post(URI(string: audience)) { req in
            try req.content.encode([
                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                "assertion": try self.getJWT(),
            ])
        }
        let accessToken = try response.content.decode(Result.self, using: JSONDecoder()).access_token
        return accessToken
    }
}
