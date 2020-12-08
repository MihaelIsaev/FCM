import Vapor

extension Request {
    public var fcm: FCM {
        .init(request: self)
    }
}
