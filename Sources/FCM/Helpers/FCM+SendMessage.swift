import Foundation
import Vapor

extension FCM {
    public func send(_ message: FCMMessageDefault) async throws -> String {
        try await _send(message)
    }
    
    private func _send(_ message: FCMMessageDefault) async throws -> String {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
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

        let url = actionsBaseURL + configuration.projectId + "/messages:send"
        let accessToken = try await getAccessToken()
        
        var headers = HTTPHeaders()
        headers.bearerAuthorization = .init(token: accessToken)
        
        let response = try await self.client.post(URI(string: url), headers: headers) { req in
            struct Payload: Content {
                let message: FCMMessageDefault
            }
            let payload = Payload(message: message)
            try req.content.encode(payload)
        }
            
        struct Result: Decodable {
            let name: String
        }
        let result = try response.content.decode(Result.self)
        return result.name
    }
}
