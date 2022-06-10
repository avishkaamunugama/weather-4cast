//
//  DailyWeatherView.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct DailyWeatherView: View {
    
    var forecast : ForecastViewModel
    @EnvironmentObject var weatherManager : WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing:15) {
            
            // Loops through all available daily forecasts
            ForEach(forecast.dailyForecast, id:\.dt) { day in
                HStack {
                    VStack(alignment:.leading, spacing: 0) {
                        
                        // Main info date, temperature
                        HStack {
                            Text(forecast.day(from: day))
                                .font(.headline.weight(.bold))
                            Spacer()
                            Group {
                                Text(forecast.temp(from: day))
                                    .font(.title2.weight(.bold))
                                Text(weatherManager.inCelcius ? "°C" : "°F")
                                    .padding(.leading, -8)
                                    .padding(.top, -3)
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(accentColor())
                            }
                            .onTapGesture {
                                weatherManager.toggleUnits()
                            }
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        
                        // Other info
                        HStack {
                            Group {
                                Image("Humidity")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.secondary)
                                    .frame(height: 20)
                                Text(forecast.humidity(from: day))
                                    .fixedSize()
                                    .font(.subheadline.weight(.light))
                            }
                            Spacer()
                            Group {
                                Image("Pressure")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.secondary)
                                    .frame(height: 20)
                                Text(forecast.pressure(from: day))
                                    .fixedSize()
                                    .font(.subheadline.weight(.light))
                            }
                            Spacer()
                            Group {
                                Image("Wind Speed")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.secondary)
                                    .frame(height: 20)
                                Text(forecast.windSpeed(from: day))
                                    .fixedSize()
                                    .font(.subheadline.weight(.light))
                            }
                        }
                    }
                    
                    // Weather image
                    WebImage(url: forecast.weatherIconURL(from: day))
                        .resizable()
                        .placeholder {
                            ProgressView()
                                .padding()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 64)
                        .background(colorScheme == .dark ? .clear : .secondary)
                        .clipShape(Circle())
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.thickMaterial)
                .cornerRadius(24)
            }
        }
        .padding(.horizontal)
    }
    
    func accentColor() -> Color {
        return colorScheme == .dark ? .yellow : .blue
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView(forecast: ForecastViewModel(currentForecast: previewForecast.current, hourlyForecast: previewForecast.hourly, dailyForecast: previewForecast.daily, inCelcius: true))
            .environmentObject(WeatherManager())
            .environmentObject(LocationManager())
    }
}
