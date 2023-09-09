import Vapor

extension Request {
    public var fcm: FCM {
        fcm(.default)
    }

    public func fcm(_ id: FCM.ID) -> FCM {
        FCM.Storage(application: application)
            .client(id)
    }
}
