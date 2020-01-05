//
//  FCMAndroidNotificationLightSettings.swift
//  
//
//  Created by Oleh Hudeichuk on 13.12.2019.
//

public typealias FCMAndroidNotificationLightSettingsColor = FCMAndroidNotificationLightSettings.Color

public struct FCMAndroidNotificationLightSettings: Codable, Equatable {
    /// Required. Set color of the LED with google.type.Color.
    public var color: Color

    /// Required. Along with light_off_duration, define the blink rate of LED flashes.
    /// Resolution defined by proto.Duration
    /// A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var light_on_duration: String

    /// Required. Along with light_on_duration, define the blink rate of LED flashes.
    /// Resolution defined by proto.Duration
    /// A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var light_off_duration: String
    
    public init (color: Color,
                    light_on_duration: String,
                    light_off_duration: String) {
        self.color = color
        self.light_on_duration = light_on_duration
        self.light_off_duration = light_off_duration
    }
}

extension FCMAndroidNotificationLightSettings {
    public struct Color: Codable, Equatable {
        public var red, green, blue, alpha: Float
        
        public init (red: Float, green: Float, blue: Float, alpha: Float) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
}
