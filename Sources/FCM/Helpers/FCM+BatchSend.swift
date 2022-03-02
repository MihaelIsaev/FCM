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
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }
        let boundary = "subrequest_boundary"
        var body = ByteBufferAllocator().buffer(capacity: 0)

        var headers = HTTPHeaders()
        headers.contentType = .init(type: "multipart", subType: "mixed", parameters: ["boundary": boundary])
        
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
                
                let payload = Payload(message: message)
                try partBody.writeJSONEncodable(payload)
                
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
        }
        try await response.validate()
        
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
            if let data = body.readData(length: body.readableBytes) {
                let str = String(decoding: data, as: UTF8.self)
                var trimmedString = str.components(separatedBy: .whitespacesAndNewlines).joined()
                let projectPath = "projects/\(configuration.projectId)/messages/"
                if trimmedString.contains(projectPath) {
                    if !trimmedString.contains("{") {
                        trimmedString.insert("{", at: trimmedString.startIndex)
                    }
                    if !trimmedString.contains("}") {
                        trimmedString.insert("}", at: trimmedString.endIndex)
                    }
                    print(trimmedString)
                    
                    if let data = trimmedString.data(using: .utf8) {
                        if let name = try? jsonDecoder.decode(Result.self, from: data).name {
                            result.append(name)
                        }
                    }
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

private class MultipartParserOutputReceiver {
    var parts: [MultipartPart] = []
    var headers: HTTPHeaders = [:]
    var body: ByteBuffer = ByteBuffer()

    static func collectOutput(_ data: String, boundary: String) throws -> MultipartParserOutputReceiver {
        try collectOutput(ByteBuffer(string: data), boundary: boundary)
    }

    static func collectOutput(_ data: ByteBuffer, boundary: String) throws -> MultipartParserOutputReceiver {
        let output = MultipartParserOutputReceiver()
        let parser = MultipartParser(boundary: boundary)
        output.setUp(with: parser)
        try parser.execute(data)
        return output
    }

    func setUp(with parser: MultipartParser) {
        parser.onHeader = { (field, value) in
            self.headers.replaceOrAdd(name: field, value: value)
        }
        parser.onBody = { new in
            self.body.writeBuffer(&new)
        }
        parser.onPartComplete = {
            let part = MultipartPart(headers: self.headers, body: self.body)
            self.headers = [:]
            self.body = ByteBuffer()
            self.parts.append(part)
        }
    }
}
private extension Collection {
    func chunked(by maxLength: Int) -> [SubSequence] {
        precondition(maxLength > 0, "groups must be greater than zero")
        var start = startIndex
        return stride(from: 0, to: count, by: maxLength).map { _ in
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}

extension ByteBuffer {
    var string: String {
        String(buffer: self)
    }
}
