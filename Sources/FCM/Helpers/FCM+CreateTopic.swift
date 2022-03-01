import Foundation
import Vapor

extension FCM {
    public func createTopic(_ name: String? = nil, tokens: String...) async throws -> String {
        try await createTopic(name, tokens: tokens)
    }

    public func createTopic(_ name: String? = nil, tokens: String..., on eventLoop: EventLoop) async throws -> String {
        try await createTopic(name, tokens: tokens)
    }

    public func createTopic(_ name: String? = nil, tokens: [String]) async throws -> String {
        try await _createTopic(name, tokens: tokens)
    }

    public func createTopic(_ name: String? = nil, tokens: [String], on eventLoop: EventLoop) async throws -> String {
        try await _createTopic(name, tokens: tokens)
    }

    private func _createTopic(_ name: String? = nil, tokens: [String]) async throws -> String {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        guard let serverKey = configuration.serverKey else {
            fatalError("FCM: CreateTopic: Server Key is missing.")
        }
        let url = self.iidURL + "batchAdd"
        let name = name ?? UUID().uuidString
        let accessToken = try await getAccessToken()
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "key=\(serverKey)")
        
        var res = try await self.client.post(URI(string: url), headers: headers)
        struct Payload: Content {
            let to: String
            let registration_tokens: [String]
            
            init(to: String, registration_tokens: [String]) {
                self.to = "/topics/\(to)"
                self.registration_tokens = registration_tokens
            }
        }
        let payload = Payload(to: name, registration_tokens: tokens)
        try res.content.encode(payload)
        return name
//        return getAccessToken().flatMap { accessToken async throws -> ClientResponse in
//            var headers = HTTPHeaders()
//            headers.add(name: .authorization, value: "key=\(serverKey)")
//
//            return self.client.post(URI(string: url), headers: headers) { (req) in
//                struct Payload: Content {
//                    let to: String
//                    let registration_tokens: [String]
//
//                    init(to: String, registration_tokens: [String]) {
//                        self.to = "/topics/\(to)"
//                        self.registration_tokens = registration_tokens
//                    }
//                }
//                let payload = Payload(to: name, registration_tokens: tokens)
//                try req.content.encode(payload)
//            }
//        }
//        .validate()
//        .map { _ in
//            return name
//        }
    }
}
