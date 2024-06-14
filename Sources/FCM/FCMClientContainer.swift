//
//  FCMClientContainer.swift
//
//
//  Created by Alessandro Di Maio on 07/09/23.
//

import Foundation
import NIOConcurrencyHelpers
import Vapor


class FCMClientContainer {
    private let application: Application
    private var clients: [FCM.ID: FCM]
    private let lock: NIOLock

    init(application: Application) {
        self.application = application
        clients = [:]
        lock = .init()
    }

    func client(_ id: FCM.ID) -> FCM {
        guard let client = clients[id] else {
            fatalError("No clients configured for \(id)")
        }

        return client
    }

    func use(_ id: FCM.ID, configuration: FCMConfiguration) throws {
        lock.lock()
        defer { lock.unlock() }

        guard !clients.keys.contains(id) else {
            fatalError("Cannot change fcm client config of \(id) while running.")
        }

        let client = FCM(
            client: application.client,
            configuration: configuration
        )
        
        clients[id] = client
    }
}
