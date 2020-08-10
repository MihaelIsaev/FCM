import Foundation
import Vapor

extension FCM {
    public func deleteTopic(_ name: String, tokens: String...) -> EventLoopFuture<Void> {
        deleteTopic(name, tokens: tokens)
    }

    public func deleteTopic(_ name: String, tokens: String..., on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        deleteTopic(name, tokens: tokens).hop(to: eventLoop)
    }

    public func deleteTopic(_ name: String, tokens: [String]) -> EventLoopFuture<Void> {
        _deleteTopic(name, tokens: tokens)
    }

    public func deleteTopic(_ name: String, tokens: [String], on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        _deleteTopic(name, tokens: tokens).hop(to: eventLoop)
    }

    private func _deleteTopic(_ name: String, tokens: [String]) -> EventLoopFuture<Void> {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        guard let serverKey = configuration.serverKey else {
            fatalError("FCM: DeleteTopic: Server Key is missing.")
        }
        let url = self.iidURL + "batchRemove"
        return getAccessToken().flatMap { accessToken -> EventLoopFuture<ClientResponse> in
            struct Payload: Content {
                let to: String
                let registration_tokens: [String]

                init(to: String, registration_tokens: [String]) {
                    self.to = "/topics/\(to)"
                    self.registration_tokens = registration_tokens
                }
            }

            var headers = HTTPHeaders()
            headers.add(name: .authorization, value: "key=\(serverKey)")

            return self.client.post(URI(string: url), headers: headers) { (req) in
                let payload = Payload(to: name, registration_tokens: tokens)
                try req.content.encode(payload)
            }
        }.flatMapThrowing { res in
            guard 200 ..< 300 ~= res.status.code else {
                if let googleError = try? res.content.decode(GoogleError.self) {
                    throw googleError
                } else {
                    throw Abort(.internalServerError, reason: res.body?.description)
                }
            }
        }
    }
}
