import Vapor

extension Application {
    public var fcm: FCM {
        .init(application: self)
    }
}
