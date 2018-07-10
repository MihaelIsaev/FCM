import Foundation
import Vapor

extension FCM {
    public convenience init() {
        guard let fcmEmail = Environment.get("fcmEmail"),
            let fcmKeyPath = Environment.get("fcmKeyPath"),
            let fcmProjectId = Environment.get("fcmProjectId")
            else {
                fatalError("FCM ENV variables not set")
        }
        self.init(email: fcmEmail, projectId: fcmProjectId, pathToKey: fcmKeyPath)
    }
}
