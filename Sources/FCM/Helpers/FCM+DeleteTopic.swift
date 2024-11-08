import Foundation
import Vapor

extension FCM {
    public func deleteTopic(_ name: String, tokens: String...) async throws {
        try await deleteTopic(name, tokens: tokens)
    }

    public func deleteTopic(_ name: String, tokens: [String]) async throws {
        try await _deleteTopic(name, tokens: tokens)
    }

    private func _deleteTopic(_ name: String, tokens: [String]) async throws {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        guard let serverKey = configuration.serverKey else {
            fatalError("FCM: DeleteTopic: Server Key is missing.")
        }
        
        let _ = try await getAccessToken()
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "key=\(serverKey)")
        
        let url = self.iidURL + "batchRemove"
        
        let response = try await self.client.post(URI(string: url), headers: headers) { (req) in
            struct Payload: Content {
                let to: String
                let registration_tokens: [String]
                
                init(to: String, registration_tokens: [String]) {
                    self.to = "/topics/\(to)"
                    self.registration_tokens = registration_tokens
                }
            }
            let payload = Payload(to: name, registration_tokens: tokens)
            try req.content.encode(payload)
        }
        
        try response.validate()
    }
}
