import Foundation
import Vapor

extension FCM {
    public convenience init() {
        if let fcmEmail = Environment.get("fcmEmail"),
            let fcmKeyPath = Environment.get("fcmKeyPath"),
            let fcmProjectId = Environment.get("fcmProjectId") {
            self.init(email: fcmEmail, projectId: fcmProjectId, pathToKey: fcmKeyPath)
        } else if let fcmServiceAccountKeyPath = Environment.get("fcmServiceAccountKeyPath") {
            self.init(pathToServiceAccountKey: fcmServiceAccountKeyPath)
        } else {
            fatalError("FCM ENV variables not set")
        }
    }
}
