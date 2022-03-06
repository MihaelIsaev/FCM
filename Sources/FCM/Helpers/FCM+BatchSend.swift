import Foundation
import Vapor

extension FCM {

    public typealias BatchResult = Result<String, Error>

    public func batchSend(_ message: FCMMessageDefault, tokens: String...) -> EventLoopFuture<[BatchResult]> {
        _send(message, tokens: tokens)
    }

    public func batchSend(_ message: FCMMessageDefault, tokens: String..., on eventLoop: EventLoop) -> EventLoopFuture<[BatchResult]> {
        _send(message, tokens: tokens).hop(to: eventLoop)
    }

    public func batchSend(_ message: FCMMessageDefault, tokens: [String]) -> EventLoopFuture<[BatchResult]> {
        _send(message, tokens: tokens)
    }

    public func batchSend(_ message: FCMMessageDefault, tokens: [String], on eventLoop: EventLoop) -> EventLoopFuture<[BatchResult]> {
        _send(message, tokens: tokens).hop(to: eventLoop)
    }

    private func _send(_ message: FCMMessageDefault, tokens: [String]) -> EventLoopFuture<[BatchResult]> {
        guard let configuration = self.configuration else {
            fatalError("FCM not configured. Use app.fcm.configuration = ...")
        }

        let urlPath = URI(string: actionsBaseURL + configuration.projectId + "/messages:send").path

        return getAccessToken().flatMap { accessToken in
            tokens.chunked(into: 500).map { chunk in
                self._sendChunk(
                    message,
                    tokens: chunk,
                    urlPath: urlPath,
                    accessToken: accessToken
                )
            }
            .flatten(on: self.client.eventLoop)
            .map { $0.flatMap { $0 } }
        }
    }

    private func _sendChunk(
        _ message: FCMMessageDefault,
        tokens: [String],
        urlPath: String,
        accessToken: String
    ) -> EventLoopFuture<[BatchResult]> {
        var body = ByteBufferAllocator().buffer(capacity: 0)
        let boundary = "subrequest_boundary"

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

                return MultipartPart(headers: ["Content-Type": "application/http"], body: partBody)
            }

            try MultipartSerializer().serialize(parts: parts, boundary: boundary, into: &body)
        } catch {
            return client.eventLoop.makeFailedFuture(error)
        }

        var headers = HTTPHeaders()
        headers.contentType = .init(type: "multipart", subType: "mixed", parameters: ["boundary": boundary])
        headers.bearerAuthorization = .init(token: accessToken)

        return self.client
            .post(URI(string: batchURL), headers: headers) { req in
                req.body = body
            }
            .validate()
            .flatMapThrowing { (res: ClientResponse) in
                guard
                    let boundary = res.headers.contentType?.parameters["boundary"]
                else {
                    throw Abort(.internalServerError, reason: "FCM: Missing \"boundary\" in batch response headers")
                }
                guard
                    let body = res.body
                else {
                    throw Abort(.internalServerError, reason: "FCM: Missing response body from batch operation")
                }

                struct Result: Decodable {
                    let name: String
                }

                let jsonDecoder = JSONDecoder()
                var results: [BatchResult] = []

                let parser = MultipartParser(boundary: boundary)

                var partBody: ByteBuffer = ByteBuffer()
                parser.onBody = { new in
                    partBody.writeBuffer(&new)
                }
                parser.onPartComplete = {
                    defer {
                        partBody = ByteBuffer()
                    }

                    let bytes = partBody.readableBytesView
                    if let indexOfBodyStart = bytes.firstIndex(of: 0x7B) /* '{' */ {
                        partBody.moveReaderIndex(to: indexOfBodyStart)
                        if let name = try? jsonDecoder.decode(Result.self, from: partBody).name {
                            results.append(.success(name))
                        } else if let error = try? jsonDecoder.decode(GoogleError.self, from: partBody) {
                            results.append(.failure(error))
                        } else {
                            results.append(.failure(FCMError(errorCode: .unspecified)))
                        }
                    }
                }

                try parser.execute(body)

                return results
            }
    }
}

extension FCM {

    @available(*, unavailable, message: "Use function that returns `EventLoopFuture<[BatchResult]>`")
    public func batchSend(_ message: FCMMessageDefault, tokens: String...) -> EventLoopFuture<[String]> {
        fatalError()
    }

    @available(*, unavailable, message: "Use function that returns `EventLoopFuture<[BatchResult]>`")
    public func batchSend(_ message: FCMMessageDefault, tokens: String..., on eventLoop: EventLoop) -> EventLoopFuture<[String]> {
        fatalError()
    }

    @available(*, unavailable, message: "Use function that returns `EventLoopFuture<[BatchResult]>`")
    public func batchSend(_ message: FCMMessageDefault, tokens: [String]) -> EventLoopFuture<[String]> {
        fatalError()
    }

    @available(*, unavailable, message: "Use function that returns `EventLoopFuture<[BatchResult]>`")
    public func batchSend(_ message: FCMMessageDefault, tokens: [String], on eventLoop: EventLoop) -> EventLoopFuture<[String]> {
        fatalError()
    }
}

private extension Collection where Index == Int {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
