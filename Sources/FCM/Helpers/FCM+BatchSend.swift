import Foundation
import Vapor
import MultipartKit

extension FCM {
    public func batchSend(_ message: FCMMessageDefault, tokens: String...) async throws -> [String] {
        try await _send(message, tokens: tokens)
    }
    
    public func batchSend(_ message: FCMMessageDefault, tokens: String..., on eventLoop: EventLoop) async throws -> [String] {
        try await _send(message, tokens: tokens)
    }
    
    public func batchSend(_ message: FCMMessageDefault, tokens: [String]) async throws -> [String]{
        try await _send(message, tokens: tokens)
    }
    
    public func batchSend(_ message: FCMMessageDefault, tokens: [String], on eventLoop: EventLoop) async throws -> [String] {
        try await _send(message, tokens: tokens)
    }
    
    private func _send(_ message: FCMMessageDefault, tokens: [String]) async throws -> [String] {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        
        let urlPath = URI(string: actionsBaseURL + configuration.projectId + "/messages:send").path
        let accessToken = try await getAccessToken()
        let chunked = tokens.chunked(into: 500).joined()
        
        return try await self._sendChunk(
            message,
            tokens: Array(chunked),
            urlPath: urlPath,
            accessToken: accessToken
        )
    }
    
    private func _sendChunk(
        _ message: FCMMessageDefault,
        tokens: [String],
        urlPath: String,
        accessToken: String
    ) async throws -> [String] {
        let boundary = "subrequest_boundary"

        var headers = HTTPHeaders()
        headers.contentType = .init(type: "multipart", subType: "mixed", parameters: ["boundary": boundary])
        headers.bearerAuthorization = .init(token: accessToken)
        
        var body = ByteBufferAllocator().buffer(capacity: 0)
        
        struct Payload: Encodable {
            let message: FCMMessageDefault
        }
        
        do {
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
                
                return MultipartPart(headers: [
                    "Content-Type": "application/http",
                    "Content-Transfer-Encoding": "binary",
                    "Authorization": "Bearer \(accessToken)"
                ], body: partBody)
            }
            
            try MultipartSerializer().serialize(parts: parts, boundary: boundary, into: &body)
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
        
        let response = try await self.client.post(URI(string: self.batchURL), headers: headers) { req in
            req.body = body
            print("REQUEST BODY", String(buffer: body))
        }
        try await response.validate()
        
        guard
            let boundary = response.headers.contentType?.parameters["boundary"]
        else {
            throw Abort(.internalServerError, reason: "FCM: Missing \"boundary\" in batch response headers")
        }
        print("RESPONSE BOUNDARY", boundary)
        guard
            let body = response.body
        else {
            throw Abort(.internalServerError, reason: "FCM: Missing response body from batch operation")
        }
        print("RESPONSE BODY", String(buffer: body))

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
