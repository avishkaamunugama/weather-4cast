//
//  CurrentWeatherView.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CurrentWeatherView: View {
    
    @Binding var searchText: String
    @Binding var placemarkName: String
    var forecast : ForecastViewModel
    @EnvironmentObject var weatherManager : WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        VStack(spacing:15) {
            VStack {
                
                // Today's date
                HStack {
                    Text("Today")
                        .font(.title3.weight(.medium))
                    Spacer()
                    Text(forecast.today(from: forecast.currentForecast))
                        .font(.headline.weight(.medium))
                }
                
                // Temperature
                HStack {
                    VStack(alignment:.leading) {
                        HStack(alignment:.top) {
                            Text(forecast.temp(from: forecast.currentForecast))
                                .font(.system(size: 50).weight(.bold))
                            Text(weatherManager.inCelcius ? "°C" : "°F")
                                .padding(.leading, -8)
                                .padding(.top, 6)
                                .font(.title.weight(.bold))
                                .foregroundColor(accentColor())
                        }
                        .onTapGesture {
                            weatherManager.toggleUnits()
                        }
                        
                        Text(forecast.overview(from: forecast.currentForecast))
                            .font(.title3.weight(.bold))
                    }
                    
                    Spacer()
                    
                    // Weather image
                    WebImage(url: forecast.weatherIconURL(from: forecast.currentForecast))
                        .resizable()
                        .placeholder {
                            ProgressView()
                                .padding(50)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .background(colorScheme == .dark ? .clear : .secondary)
                        .clipShape(Circle())
                }
                
                // User location and search text
                if weatherManager.isValidSearch && !searchText.isEmpty {
                    HStack {
                        Spacer()
                        Text("Showing forecast for ")
                            .font(.subheadline.weight(.light))
                        + Text(searchText)
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(accentColor())
                        Spacer()
                    }
                }
                else {
                    HStack {
                        Spacer()
                        Image("Mappin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundColor(accentColor())
                        
                        Text(placemarkName)
                            .font(.subheadline.weight(.light))
                        Spacer()
                    }
                    .onTapGesture {
                        locationManager.lookUpCurrentLocation { userLocation in
                            placemarkName = userLocation?.name ?? "..."
                        }
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal,20)
            .background(.thickMaterial)
            .cornerRadius(24)
            
            // Other info component
            HStack {
                VStack(spacing:0) {
                    Image("Humidity")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.secondary)
                        .frame(height: 38)
                        .padding(.bottom, 10)
                    Text(forecast.humidity(from: forecast.currentForecast))
                        .font(.headline.weight(.light))
                    Text("Humidity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(spacing:0) {
                    Image("Pressure")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.secondary)
                        .frame(height: 38)
                        .padding(.bottom, 10)
                    Text(forecast.pressure(from: forecast.currentForecast))
                        .font(.headline.weight(.light))
                    Text("Pressure")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(spacing:0) {
                    Image("Wind Speed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.secondary)
                        .frame(height: 38)
                        .padding(.bottom, 10)
                    Text(forecast.windSpeed(from: forecast.currentForecast))
                        .font(.headline.weight(.light))
                    Text("Wind Speed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
            }
            .padding(.vertical)
            .padding(.horizontal,20)
            .background(.thickMaterial)
            .cornerRadius(24)
        }
        .onAppear() {
            locationManager.requestLocation()
            locationManager.lookUpCurrentLocation { userLocation in
                placemarkName = userLocation?.name ?? "..."
            }
        }
    }
    
    func accentColor() -> Color {
        return colorScheme == .dark ? .yellow : .blue
    }
    
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(searchText: .constant(""), placemarkName: .constant(""), forecast: ForecastViewModel(currentForecast: previewForecast.current, hourlyForecast: previewForecast.hourly, dailyForecast: previewForecast.daily, inCelcius: true))
            .environmentObject(WeatherManager())
            .environmentObject(LocationManager())
    }
}
