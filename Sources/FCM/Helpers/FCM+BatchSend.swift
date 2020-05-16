import Foundation
import Vapor

extension FCM {
    public func batchSend(_ message: FCMMessageDefault, tokens: String...) -> EventLoopFuture<[String]> {
        _send(message, tokens: tokens)
    }
    
    public func batchSend(_ message: FCMMessageDefault, tokens: String..., on eventLoop: EventLoop) -> EventLoopFuture<[String]> {
        _send(message, tokens: tokens).hop(to: eventLoop)
    }
    
    public func batchSend(_ message: FCMMessageDefault, tokens: [String]) -> EventLoopFuture<[String]> {
        _send(message, tokens: tokens)
    }
    
    public func batchSend(_ message: FCMMessageDefault, tokens: [String], on eventLoop: EventLoop) -> EventLoopFuture<[String]> {
        _send(message, tokens: tokens).hop(to: eventLoop)
    }
    
    private func _send(_ message: FCMMessageDefault, tokens: [String]) -> EventLoopFuture<[String]> {
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
        var preparedTokens: [[String]] = []
        tokens.enumerated().forEach { i, token in
            if Double(i).truncatingRemainder(dividingBy: 1) == 0 {
                preparedTokens.append([token])
            } else {
                if var arr = preparedTokens.popLast() {
                    arr.append(token)
                    preparedTokens.append(arr)
                } else {
                    preparedTokens.append([token])
                }
            }
        }
        var deviceGroups: [String: [String]] = [:]
        return preparedTokens.map { tokens in
            createTopic(tokens: tokens).map {
                deviceGroups[$0] = tokens
            }
        }.flatten(on: application.eventLoopGroup.next()).flatMap {
            var results: [String] = []
            return deviceGroups.map { deviceGroup in
                let message = message
                message.token = nil
                message.condition = nil
                message.topic = deviceGroup.key
                return self.send(message).map {
                    results.append($0)
                }.flatMap {
                    self.deleteTopic(deviceGroup.key, tokens: deviceGroup.value)
                }
            }.flatten(on: self.application.eventLoopGroup.next()).transform(to: results)
        }
    }
}
