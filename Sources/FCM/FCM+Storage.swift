//
//  File.swift
//
//
//  Created by Alessandro Di Maio on 07/09/23.
//

import Foundation
import NIOConcurrencyHelpers
import Vapor

extension FCM {
    public struct Storage {
        private let application: Application

        var container: FCMClientContainer {
            guard let existingContainer = application.storage[ContainerKey.self] else {
                let lock = application.locks.lock(for: ContainerKey.self)
                lock.lock()
                defer { lock.unlock() }

                let new = FCMClientContainer(application: application)
                application.storage.set(ContainerKey.self, to: new)
                return new
            }

            return existingContainer
        }

        init(application: Application) {
            self.application = application
        }

        func client(_ id: FCM.ID) -> FCM {
            container.client(id)
        }
    }
}

extension FCM.Storage {
    private struct ContainerKey: StorageKey, LockKey {
        typealias Value = FCMClientContainer
    }
}
