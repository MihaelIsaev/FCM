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
        .flatMapThrowing { res throws -> String  in
            if res.status.code != 200 {
                let code = "Code: \(res.status.code)"
                let message = "Message: \(res.content))"
                let reason = "[FCM] Unable to refresh access token. \(code) \(message)"
                throw Abort(.internalServerError, reason: reason)
            }

            struct Result: Codable {
                var access_token: String
            }
            guard let result = try? res.content.decode(Result.self) else {
                throw Abort(.notFound, reason: "Data not found")
            }
            return result.access_token
        }
    }
}
