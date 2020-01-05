import Foundation
import Vapor

extension FCM {
    func getAccessToken() -> EventLoopFuture<String> {
        guard let gAuth = gAuth else {
            fatalError("FCM gAuth can't be nil")
        }
        if !gAuth.hasExpired, let token = accessToken {
            return client.eventLoopGroup.future(token)
        }
        return application.eventLoopGroup.future(()).flatMapThrowing { _ throws -> Data in
            var payload: [String: String] = [:]
            payload["grant_type"] = "urn:ietf:params:oauth:grant-type:jwt-bearer"
            payload["assertion"] = try self.getJWT()
            return try JSONEncoder().encode(payload)
        }.flatMapThrowing { data -> HTTPClient.Request in
            var headers = HTTPHeaders()
            headers.add(name: "Content-Type", value: "application/json")
            return try HTTPClient.Request(url: self.audience, method: .POST, headers: headers, body: .data(data))
        }.flatMap { request in
            return self.client.execute(request: request).flatMapThrowing { res throws -> String  in
                guard let body = res.body, let data = body.getData(at: body.readerIndex, length: body.readableBytes) else {
                    throw Abort(.notFound, reason: "Data not found")
                }
                if res.status.code != 200 {
                    let code = "Code: \(res.status.code)"
                    let message = "Message: \(String(data: data, encoding: .utf8) ?? "n/a"))"
                    let reason = "[FCM] Unable to refresh access token. \(code) \(message)"
                    throw Abort(.internalServerError, reason: reason)
                }
                struct Result: Codable {
                    var access_token: String
                }
                guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
                    throw Abort(.notFound, reason: "Data not found")
                }
                return result.access_token
            }
        }
    }
}
