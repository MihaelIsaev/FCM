//
//  FCMAndroidNotificationLightSettings.swift
//  
//
//  Created by Oleh Hudeichuk on 13.12.2019.
//

public struct FCMAndroidNotificationLightSettingsColor: Codable, Equatable {

    public var red: Float

    public var green: Float

    public var blue: Float

    public var alpha: Float
}

public struct FCMAndroidNotificationLightSettings: Codable, Equatable {

    ///    Required. Set color of the LED with google.type.Color.
    public var color: FCMAndroidNotificationLightSettingsColor

    ///    Required. Along with light_off_duration, define the blink rate of LED flashes. Resolution defined by proto.Duration
    ///    A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var light_on_duration: String

    ///    Required. Along with light_on_duration, define the blink rate of LED flashes. Resolution defined by proto.Duration
    ///    A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    public var light_off_duration: String
}

