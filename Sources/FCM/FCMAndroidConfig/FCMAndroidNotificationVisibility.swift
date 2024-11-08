//
//  FCMAndroidNotificationVisibility.swift
//  
//
//  Created by Oleh Hudeichuk on 13.12.2019.
//

public enum FCMAndroidNotificationVisibility: String, Sendable, Codable, Equatable {
    /// If unspecified, default to Visibility.PRIVATE.
    case unspecified = "VISIBILITY_UNSPECIFIED"

    /// Show this notification on all lockscreens, but conceal sensitive or private information on secure lockscreens.
    case `private` = "PRIVATE"

    /// Show this notification in its entirety on all lockscreens.
    case `public` = "PUBLIC"

    /// Do not reveal any part of this notification on a secure lockscreen.
    case secret = "SECRET"
}
