//
//  HourlyWeatherView.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HourlyWeatherView: View {
    
    var forecast : ForecastViewModel
    @EnvironmentObject var weatherManager : WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing:15) {
                
                // Loops through all available hourly forecasts
                ForEach(forecast.hourlyForecast[0..<13], id:\.dt) { hour in
                    VStack(alignment:.leading, spacing: 0) {
                        
                        // Weather image
                        HStack {
                            Spacer()
                            WebImage(url: forecast.weatherIconURL(from: hour))
                                .resizable()
                                .placeholder {
                                    ProgressView()
                                        .padding()
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 75)
                                .background(colorScheme == .dark ? .clear : .secondary)
                                .clipShape(Circle())
                                .padding(.top, colorScheme == .dark ? 0 : 10)
                        }
                        
                        // Time
                        Text(forecast.hour(from: hour))
                            .font(.subheadline)
                            .padding(.bottom,5)
                        
                        // Temperature
                        HStack(alignment:.top) {
                            Text(forecast.temp(from: hour))
                                .font(.system(size: 30).weight(.bold))
                            Text(weatherManager.inCelcius ? "°C" : "°F")
                                .padding(.leading,-8)
                                .padding(.top,3)
                                .font(.headline.weight(.bold))
                                .foregroundColor(accentColor())
                        }
                        .onTapGesture {
                            weatherManager.toggleUnits()
                        }
                        
                        // Overview
                        Text(forecast.overview(from: hour))
                            .fixedSize()
                            .font(.subheadline)
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .background(.thickMaterial)
                    .frame(width: 150)
                    .cornerRadius(24)
                }
            }
            .padding(.leading)
        }
    }
    
    func accentColor() -> Color {
        return colorScheme == .dark ? .yellow : .blue
    }
}

struct HourlyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherView(forecast: ForecastViewModel(currentForecast: previewForecast.current, hourlyForecast: previewForecast.hourly, dailyForecast: previewForecast.daily, inCelcius: true))
            .environmentObject(WeatherManager())
            .environmentObject(LocationManager())
    }
}
