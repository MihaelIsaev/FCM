//
//  FCM+ID.swift
//
//
//  Created by Alessandro Di Maio on 08/09/23.
//

import Foundation

extension FCM {
    public struct ID: Hashable, ExpressibleByStringLiteral {
        public typealias StringLiteralType = String

        public let rawValue: String

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public init(_ value: String) {
            rawValue = value
        }

        public init(_ id: FCM.ID) {
            rawValue = id.rawValue
        }
    }
}

extension FCM.ID {
    public static let `default`: Self = "default"
}
