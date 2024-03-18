import Vapor

extension Application {
    public var fcm: FCM.Storage {
        .init(application: self)
    }
}
