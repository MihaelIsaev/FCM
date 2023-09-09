import Vapor

extension Application {
    public var fcm: FCM.Storage {
        fcm(.default)
    }

    public func fcm(_ id: FCM.ID) -> FCM.Storage {
        .init(application: self)
    }
}
