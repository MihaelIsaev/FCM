import Vapor

extension Request {
    public var fcm: FCM {
        .init(application: application)
    }
}
