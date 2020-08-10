import Foundation
import Vapor

extension FCM {
    public func send(_ message: FCMMessageDefault) -> EventLoopFuture<String> {
        _send(message)
    }
    
    public func send(_ message: FCMMessageDefault, on eventLoop: EventLoop) -> EventLoopFuture<String> {
        _send(message).hop(to: eventLoop)
    }
    
    private func _send(_ message: FCMMessageDefault) -> EventLoopFuture<String> {
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
        return getAccessToken().flatMap { accessToken -> EventLoopFuture<ClientResponse> in
            var headers = HTTPHeaders()
            headers.bearerAuthorization = .init(token: accessToken)

            struct Payload: Content {
                let validate_only: Bool = false
                let message: FCMMessageDefault
            }
            let payload = Payload(message: message)

            return self.client.post(URI(string: url), headers: headers) { (req) in
                try req.content.encode(payload)
            }
        }
        .flatMapThrowing { res in
            guard 200 ..< 300 ~= res.status.code else {
                if let googleError = try? res.content.decode(GoogleError.self) {
                    throw googleError
                } else {
                    let reason = res.body?.debugDescription ?? "Unable to decode Firebase response"
                    throw Abort(.internalServerError, reason: reason)
                }
            }

            struct Result: Codable {
                var name: String
            }
            guard let result = try? res.content.decode(Result.self) else {
                throw Abort(.notFound, reason: "Data not found")
            }
            return result.name
        }
    }
}
