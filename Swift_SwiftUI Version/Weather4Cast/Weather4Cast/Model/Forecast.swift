//
//  Forecast.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import Foundation

struct Forecast: Codable {
    var current: Current
    var hourly: [Current]
    var daily: [Daily]
    
    struct Current: Codable {
        var dt: Date
        var temp: Double
        var pressure: Double
        var humidity: Int
        var clouds: Int
        var wind_speed: Double
        var weather: [Weather]
    }
    
    struct Weather: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    struct Daily: Codable {
        var dt: Date
        var temp: Temp
        var pressure: Double
        var humidity: Int
        var clouds: Int
        var wind_speed: Double
        var weather: [Weather]
    }
    
    struct Temp: Codable {
        var day: Double
        var min: Double
        var max: Double
    }

}
