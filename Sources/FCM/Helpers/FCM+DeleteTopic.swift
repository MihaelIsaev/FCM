import Foundation
import Vapor

//extension FCM {
//    public func deleteTopic(_ name: String, tokens: String...) -> EventLoopFuture<Void> {
//        deleteTopic(name, tokens: tokens)
//    }
//    
//    public func deleteTopic(_ name: String, tokens: String..., on eventLoop: EventLoop) -> EventLoopFuture<Void> {
//        deleteTopic(name, tokens: tokens).hop(to: eventLoop)
//    }
//    
//    public func deleteTopic(_ name: String, tokens: [String]) -> EventLoopFuture<Void> {
//        _deleteTopic(name, tokens: tokens)
//    }
//    
//    public func deleteTopic(_ name: String, tokens: [String], on eventLoop: EventLoop) -> EventLoopFuture<Void> {
//        _deleteTopic(name, tokens: tokens).hop(to: eventLoop)
//    }
//    
//    private func _deleteTopic(_ name: String, tokens: [String]) -> EventLoopFuture<Void> {
//        guard let configuration = self.configuration else {
//            fatalError("FCM not configured. Use app.fcm.configuration = ...")
//        }
//        guard let serverKey = configuration.serverKey else {
//            fatalError("FCM: DeleteTopic: Server Key is missing.")
//        }
//        let url = self.iidURL + "batchRemove"
//        return getAccessToken().flatMapThrowing { accessToken throws -> HTTPClient.Request in
//            struct Payload: Codable {
//                let to: String
//                let registration_tokens: [String]
//                
//                init (to: String, registration_tokens: [String]) {
//                    self.to = "/topics/\(to)"
//                    self.registration_tokens = registration_tokens
//                }
//            }
//            let payload = Payload(to: name, registration_tokens: tokens)
//            let payloadData = try JSONEncoder().encode(payload)
//            var headers = HTTPHeaders()
//            headers.add(name: "Authorization", value: "key=\(serverKey)")
//            headers.add(name: "Content-Type", value: "application/json")
//            return try .init(url: url, method: .POST, headers: headers, body: .data(payloadData))
//        }.flatMap { request in
//            return self.client.execute(request: request).flatMapThrowing { res in
//                guard 200 ..< 300 ~= res.status.code else {
//                    if let body = res.body, let googleError = try? JSONDecoder().decode(GoogleError.self, from: body) {
//                        throw googleError
//                    } else {
//                        guard
//                            let bb = res.body,
//                            let bytes = bb.getBytes(at: 0, length: bb.readableBytes),
//                            let reason = String(bytes: bytes, encoding: .utf8) else {
//                            throw Abort(.internalServerError, reason: "FCM: DeleteTopic: unable to decode error response")
//                        }
//                        throw Abort(.internalServerError, reason: reason)
//                    }
//                }
//            }
//        }
//    }
//}
