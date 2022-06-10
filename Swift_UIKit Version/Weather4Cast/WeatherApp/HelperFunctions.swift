//
//  HelperFunctions.swift
//  WeatherApp
//
//  Created by Avishka Amunugama on 6/5/22.
//

import Foundation

func configureDate(_ day: Date) -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "E, MMM d"
    return dateformatter.string(from: day)
}

func weatherIconURL(from icon:String?) -> URL? {
    guard let icon = icon else { return nil }
    let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
    return URL(string: urlString)
}

func formatAsString(_ number:Double) -> String {
    return String(format: "%.0f", number)
}
