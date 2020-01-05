import Foundation
import Vapor

extension FCM {
    func getAccessToken() throws -> EventLoopFuture<String> {
        guard let gAuth = gAuth else {
            fatalError("FCM gAuth can't be nil")
        }
        if !gAuth.hasExpired, let token = accessToken {
            return client.eventLoopGroup.future(token)
        }
        var payload: [String: String] = [:]
        payload["grant_type"] = "urn:ietf:params:oauth:grant-type:jwt-bearer"
        payload["assertion"] = try getJWT()
        
        let payloadData = try JSONEncoder().encode(payload)
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        
        let request: HTTPClient.Request = try .init(url: audience,
                                                                     method: .POST,
                                                                     headers: headers,
                                                                     body: .data(payloadData))
        return client.execute(request: request).flatMapThrowing { res throws -> String in
        guard let body = res.body, let data = body.getData(at: body.readerIndex, length: body.readableBytes) else {
            throw Abort(.notFound, reason: "Data not found")
        }
            struct Result: Codable {
                var access_token: String
            }
            if res.status.code != 200 {
                let code = "Code: \(res.status.code)"
                let message = "Message: \(String(data: data, encoding: .utf8) ?? "n/a"))"
                let reason = "[FCM] Unable to refresh access token. \(code) \(message)"
                throw Abort(.internalServerError, reason: reason)
            }
            guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
                throw Abort(.notFound, reason: "Data not found")
            }
            return result.access_token
        }.flatMapErrorThrowing { error throws -> String in
            throw Abort(.internalServerError, reason: "get access token error: \(error)")
        }
    }
}
