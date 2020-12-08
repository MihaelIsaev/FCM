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

            return self.client.post(URI(string: url), headers: headers) { (req) in
                struct Payload: Content {
                    let validate_only: Bool = false
                    let message: FCMMessageDefault
                }
                let payload = Payload(message: message)
                try req.content.encode(payload)
            }
        }
        .validate()
        .flatMapThrowing { res in
            struct Result: Decodable {
                let name: String
            }
            let result = try res.content.decode(Result.self)
            return result.name
        }
    }
}
