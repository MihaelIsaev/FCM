import Foundation
import Vapor

extension FCM {
    func getAccessToken() -> EventLoopFuture<String> {
        guard let gAuth = gAuth else {
            fatalError("FCM gAuth can't be nil")
        }
        if !gAuth.hasExpired, let token = accessToken {
            return client.eventLoop.future(token)
        }

        return client.post(URI(string: audience)) { (req) in
            try req.content.encode([
                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                "assertion": try self.getJWT(),
            ])
        }
        .validate()
        .flatMapThrowing { res -> String in
            struct Result: Codable {
                let access_token: String
            }

            return try res.content.decode(Result.self, using: JSONDecoder()).access_token
        }
    }
}
