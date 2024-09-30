import Foundation
import Vapor

extension FCM {

    private func _send(_ message: FCMMessageDefault, tokens: [String]) async throws -> [String] {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }

        let urlPath = URI(string: actionsBaseURL + configuration.projectId + "/messages:send").path
        
        let accessToken = try await getAccessToken()
        
        var result = [String]()
        for chunk in tokens.chunked(into: 500) {
            let partial = try await self._sendChunk(
                message,
                tokens: chunk,
                urlPath: urlPath,
                accessToken: accessToken
            )
            result.append(contentsOf: partial)
        }
        
        return result
    }

    private func _sendChunk(
        _ message: FCMMessageDefault,
        tokens: [String],
        urlPath: String,
        accessToken: String
    ) async throws -> [String] {
        var body = ByteBufferAllocator().buffer(capacity: 0)
        let boundary = "subrequest_boundary"

        struct Payload: Encodable {
            let message: FCMMessageDefault
        }

        let parts: [MultipartPart] = try tokens.map { token in
            var partBody = ByteBufferAllocator().buffer(capacity: 0)

            partBody.writeString("""
                POST \(urlPath)\r
                Content-Type: application/json\r
                accept: application/json\r
                \r

                """)

            let message = FCMMessageDefault(
                token: token,
                notification: message.notification,
                data: message.data,
                name: message.name,
                android: message.android ?? androidDefaultConfig,
                webpush: message.webpush ?? webpushDefaultConfig,
                apns: message.apns ?? apnsDefaultConfig
            )

            try partBody.writeJSONEncodable(Payload(message: message))

            return MultipartPart(headers: ["Content-Type": "application/http"], body: partBody)
        }

        try MultipartSerializer().serialize(parts: parts, boundary: boundary, into: &body)

        var headers = HTTPHeaders()
        headers.contentType = .init(type: "multipart", subType: "mixed", parameters: ["boundary": boundary])
        headers.bearerAuthorization = .init(token: accessToken)

        let response = try await self.client
            .post(URI(string: batchURL), headers: headers) { req in
                req.body = body
            }
        
        try response.validate()

        guard
            let boundary = response.headers.contentType?.parameters["boundary"]
        else {
            throw Abort(.internalServerError, reason: "FCM: Missing \"boundary\" in batch response headers")
        }
        guard
            let body = response.body
        else {
            throw Abort(.internalServerError, reason: "FCM: Missing response body from batch operation")
        }

        struct Result: Decodable {
            let name: String
        }

        let jsonDecoder = JSONDecoder()
        var result: [String] = []

        let parser = MultipartParser(boundary: boundary)
        parser.onBody = { body in
            let bytes = body.readableBytesView
            if let indexOfBodyStart = bytes.firstIndex(of: 0x7B) /* '{' */ {
                body.moveReaderIndex(to: indexOfBodyStart)
                if let name = try? jsonDecoder.decode(Result.self, from: body).name {
                    result.append(name)
                }
            }
        }

        try parser.execute(body)

        return result
    }
}

private extension Collection where Index == Int {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
