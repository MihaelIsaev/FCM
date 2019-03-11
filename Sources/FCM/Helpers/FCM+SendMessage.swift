import Foundation
import Vapor

extension FCM {
    public func sendMessage(_ client: Client, message: FCMMessageDefault) throws -> Future<String> {
        if message.apns == nil,
            let apnsDefaultConfig = apnsDefaultConfig {
            message.apns = apnsDefaultConfig
        }
        if message.android == nil,
            let androidDefaultConfig = androidDefaultConfig {
            message.android = androidDefaultConfig
        }
        if message.webpush == nil,
            let webpushDefaultConfig = webpushDefaultConfig {
            message.webpush = webpushDefaultConfig
        }
        let url = actionsBaseURL + projectId + "/messages:send"
        return try getAccessToken(client).flatMap { accessToken in
            var headers = HTTPHeaders()
            headers.add(name: "Authorization", value: "Bearer "+accessToken)
            headers.add(name: "Content-Type", value: "application/json")
            return client.post(url, headers: headers) { req throws in
                struct Payload: Codable {
                    var validate_only: Bool
                    var message: FCMMessageDefault
                }
                let payload = Payload(validate_only: false, message: message)
                try req.content.encode(payload, as: .json)
            }.map { res in
                guard let data = res.http.body.data else {
                    throw Abort(.notFound, reason: "Data not found")
                }

                guard 200 ..< 300 ~= res.http.status.code else {
                    if let googleError = try? res.content.syncDecode(GoogleError.self) {
                        throw googleError
                    } else {
                        let reason = String(data: data, encoding: .utf8) ?? "Unable to decode Firebase response"
                        throw Abort(.internalServerError, reason: reason)
                    }
                }

                struct Result: Codable {
                    var name: String
                }
                return try res.content.syncDecode(Result.self).name
            }
        }
    }
}
