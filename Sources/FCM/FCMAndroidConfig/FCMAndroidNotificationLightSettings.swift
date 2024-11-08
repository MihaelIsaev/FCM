//
//  FCMAndroidNotificationLightSettings.swift
//  
//
//  Created by Oleh Hudeichuk on 13.12.2019.
//

public typealias FCMAndroidNotificationLightSettingsColor = FCMAndroidNotificationLightSettings.Color

public struct FCMAndroidNotificationLightSettings: Sendable, Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case color
        case lightOnDuration = "light_on_duration"
        case lightOffDuration = "light_off_duration"
    }
    
    /// Required. Set color of the LED with google.type.Color.
    public var color: Color

    /// Required. Along with light_off_duration, define the blink rate of LED flashes.
    /// Resolution defined by proto.Duration
    /// A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var lightOnDuration: String

    /// Required. Along with light_on_duration, define the blink rate of LED flashes.
    /// Resolution defined by proto.Duration
    /// A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var lightOffDuration: String
    
    init(color: Color, lightOnDuration: String, lightOffDuration: String) {
        self.color = color
        self.lightOnDuration = lightOnDuration
        self.lightOffDuration = lightOffDuration
    }
}

extension FCMAndroidNotificationLightSettings {
    public struct Color: Codable, Sendable, Equatable {
        public var red, green, blue, alpha: Float
        
        public init(red: Float, green: Float, blue: Float, alpha: Float) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
}
