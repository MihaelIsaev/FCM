import Foundation
import Vapor

extension FCM {
    struct Result: Codable {
        let access_token: String
    }
    
    func getAccessToken() async throws -> String {
        guard let gAuth = gAuth else {
            fatalError("FCM gAuth can't be nil")
        }
        if !gAuth.hasExpired, let token = accessToken {
            return token
        }
        
        var response = try await client.post(URI(string: audience))
        let json = try response.content.encode([
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion": try self.getJWT(),
        ])

        return try response.content.decode(Result.self, using: JSONDecoder()).access_token
//        return client.post(URI(string: audience)) { (req) in
//            try req.content.encode([
//                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
//                "assertion": try self.getJWT(),
//            ])
//        }
//        .validate()
//        .flatMapThrowing { res -> String in
//            struct Result: Codable {
//                let access_token: String
//            }
//
//            return try res.content.decode(Result.self, using: JSONDecoder()).access_token
//        }
    }
}
