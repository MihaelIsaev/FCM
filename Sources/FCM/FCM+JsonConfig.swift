import Foundation
import Vapor

extension FCM {
    private struct ServiceAccountKey: Codable {
        var project_id: String
        var private_key: String
        var client_email: String
    }
    
    public convenience init(pathToServiceAccountKey path: String) {
        let fm = FileManager.default
        guard let data = fm.contents(atPath: path) else {
            fatalError("FCM serviceAccountKey file doesn't exists at path: \(path)")
        }
        guard let configuration = try? JSONDecoder().decode(ServiceAccountKey.self, from: data) else {
            fatalError("FCM unable to decode serviceAccountKey from file located at: \(path)")
        }
        self.init(email: configuration.client_email, projectId: configuration.project_id, key: configuration.private_key)
    }
}
