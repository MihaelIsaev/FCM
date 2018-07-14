import Foundation
import Vapor

extension FCM {
    public convenience init(email: String, projectId: String, pathToKey path: String) {
        let fm = FileManager.default
        guard let data = fm.contents(atPath: path) else {
            fatalError("FCM pem file doesn't exists")
        }
        guard let key = String(data: data, encoding: .utf8) else {
            fatalError("FCM unable to decode key file content")
        }
        self.init(email: email, projectId: projectId, key: key)
    }
}
