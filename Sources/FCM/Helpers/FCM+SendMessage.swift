import Foundation
import Vapor

extension FCM {
    public func send(_ message: FCMMessageDefault) throws -> EventLoopFuture<String> {
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
        return try getAccessToken().flatMapFutureThrowing { accessToken in
            struct Payload: Codable {
                let validate_only: Bool
                let message: FCMMessageDefault
            }
            let payload = Payload(validate_only: false, message: message)
            let payloadData = try JSONEncoder().encode(payload)
            
            var headers = HTTPHeaders()
            headers.add(name: "Authorization", value: "Bearer \(accessToken)")
            headers.add(name: "Content-Type", value: "application/json")
            
            guard let request: HTTPClient.Request = try? .init(url: url,
                                                                                     method: .POST,
                                                                                     headers: headers,
                                                                                     body: .data(payloadData))
                else { throw Abort(.internalServerError, reason: "Unable to create request for FCM") }
            return self.client.execute(request: request).flatMapThrowing { res in
                guard 200 ..< 300 ~= res.status.code else {
                    if let body = res.body, let googleError = try? JSONDecoder().decode(GoogleError.self, from: body) {
                        throw googleError
                    } else {
                        let reason = res.body?.debugDescription ?? "Unable to decode Firebase response"
                        throw Abort(.internalServerError, reason: reason)
                    }
                }
                struct Result: Codable {
                    var name: String
                }
                guard let body = res.body, let result = try? JSONDecoder().decode(Result.self, from: body) else {
                    throw Abort(.notFound, reason: "Data not found")
                }
                return result.name
            }
        }
    }
}

extension EventLoopFuture {
    @inlinable
    public func flatMapFutureThrowing<NewValue>(file: StaticString = #file,
                                line: UInt = #line,
                                _ callback: @escaping (Value) throws -> EventLoopFuture<NewValue>) -> EventLoopFuture<NewValue> {
        return self.flatMap(file: file, line: line) { (value: Value) -> EventLoopFuture<NewValue> in
            let promise = self.eventLoop.makePromise(of: NewValue.self)
            do {
                promise.completeWith(try callback(value))
            } catch {
                promise.fail(error)
            }
            return promise.futureResult
        }
    }
}
