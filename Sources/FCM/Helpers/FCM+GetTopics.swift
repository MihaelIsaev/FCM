import Foundation
import Vapor

extension FCM {
    public func getTopics(token: String) async throws -> [String] {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        guard let serverKey = configuration.serverKey else {
            fatalError("FCM: GetTopics: Server Key is missing.")
        }
        let url = self.iidURL + "info/\(token)?details=true"
        var headers = HTTPHeaders()
        headers.add(name: .authorization, value: "key=\(serverKey)")
        let clientResponse = try await client.get(URI(string: url), headers: headers)
        try await clientResponse.validate()
        struct Result: Codable {
            let rel: Relations

            struct Relations: Codable {
                let topics: [String: TopicMetadata]
            }

            struct TopicMetadata: Codable {
                let addDate: String
            }
        }
        let result = try clientResponse.content.decode(Result.self, using: JSONDecoder())
        return Array(result.rel.topics.keys)
    }
}
