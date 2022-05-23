//
//  ForecastViewModel.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/22/22.
//

import Foundation

class ForecastViewModel {
    let currentForecast: Forecast.Current
    let hourlyForecast: [Forecast.Current]
    let dailyForecast: [Forecast.Daily]
    var inCelcius: Bool
    
    init(currentForecast: Forecast.Current, hourlyForecast: [Forecast.Current], dailyForecast: [Forecast.Daily], inCelcius: Bool) {
        self.currentForecast = currentForecast
        self.hourlyForecast = hourlyForecast
        self.dailyForecast = dailyForecast
        self.inCelcius = inCelcius
    }
    
    private var dateFormatter: DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "E, MMM d"
        
        return dateformatter
    }
    
    private var hourFormatter: DateFormatter {
        let hourformatter = DateFormatter()
        hourformatter.dateFormat = "h:mm a"
        
        return hourformatter
    }
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    private func convert(_ temp:Double) -> Double {
        if inCelcius {
            return temp
        } else {
            return (temp * (9 / 5)) + 30
        }

    }
        
    func today(from current: Forecast.Current) -> String {
        return dateFormatter.string(from: current.dt)
    }
    
    func hour(from hour: Forecast.Current) -> String {
        return hourFormatter.string(from: hour.dt)
    }
    
    func temp(from current: Forecast.Current) -> String {
        return String(format: "%.0f", convert(current.temp))
    }
    
    func overview(from current: Forecast.Current) -> String {
        return current.weather.first?.description.capitalized ?? ""
    }
    
    func clouds(from current: Forecast.Current) -> String {
        return "\(current.clouds)%"
    }
    
    func humidity(from current: Forecast.Current) -> String {
        return "\(current.humidity)%"
    }
    
    func pressure(from current: Forecast.Current) -> String {
        return "\(String(format: "%.0f", current.pressure))hpa"
    }
    
    func windSpeed(from current: Forecast.Current) -> String {
        return "\(String(format: "%.0f", current.wind_speed))km/h"
    }
    
    func weatherIconURL(from current: Forecast.Current) -> URL? {
        guard let weatherIcon = current.weather.first?.icon else { return nil }
        let urlString = "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
        return URL(string: urlString)
    }
    
    func day(from day:Forecast.Daily) -> String {
        return dateFormatter.string(from: day.dt)
    }
    
    func temp(from day:Forecast.Daily) -> String {
        return String(format: "%.0f", convert(day.temp.day))
    }
    
    func overview(from day:Forecast.Daily) -> String {
        return day.weather.first?.description.capitalized ?? ""
    }
    
    func humidity(from day:Forecast.Daily) -> String {
        return "\(day.humidity)%"
    }
    
    func pressure(from day:Forecast.Daily) -> String {
        return "\(String(format: "%.0f", day.pressure))hpa"
    }
    
    func windSpeed(from day:Forecast.Daily) -> String {
        return "\(String(format: "%.0f", day.wind_speed))km/h"
    }
    
    func weatherIconURL(from day:Forecast.Daily) -> URL? {
        guard let weatherIcon = day.weather.first?.icon else { return nil }
        let urlString = "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
        return URL(string: urlString)
    }
    
}
