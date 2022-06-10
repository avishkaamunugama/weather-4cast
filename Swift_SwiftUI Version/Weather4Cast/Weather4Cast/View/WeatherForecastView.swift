//
//  WeatherForecastView.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/23/22.
//

import SwiftUI

enum ForecastSection:String, CaseIterable {
    case today, next7Days
    
    var displayName: String {
        switch self {
        case .today:
            return "Today"
        case .next7Days:
            return "Next 7 Days"
        }
    }
}

struct WeatherForecastView: View {
    
    @State var isSearchBarVisible = false
    @State var searchText = ""
    @State var placemarkName = ""
    @State var selectedSection: ForecastSection = .today
    @EnvironmentObject var weatherManager : WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if let location = locationManager.currentLocation {
            if let forecast = weatherManager.forecast {
                
                ZStack(alignment:.topTrailing) {
                    ZStack(alignment:.bottom) {
                        ScrollView {
                                VStack(alignment:.leading) {
                                    
                                    // Main Title
                                    HStack {
                                        Text("Weather")
                                            .font(.headline.weight(.bold))
                                        + Text("4")
                                            .font(.title.weight(.bold))
                                        + Text("cast")
                                            .font(.headline.weight(.bold))
                                        Spacer()
                                    }
                                    .frame(height:45)
                                    .padding(.vertical)
                                    .padding(.leading, 25)
                                    
                                    // Todays's Weather Component
                                    CurrentWeatherView(searchText: $searchText, placemarkName: $placemarkName, forecast: forecast)
                                        .padding(.horizontal)
                                    
                                    // Custom segmented control
                                    HStack {
                                        ForEach(ForecastSection.allCases,id:\.self) { section in
                                            Button {
                                                selectedSection = section
                                            }label: {
                                                Text(section.displayName)
                                                    .font(.headline)
                                                    .foregroundColor(selectedSection == section ? .primary : .secondary)
                                                    .underline(selectedSection == section)
                                                    .padding()
                                            }
                                        }
                                    }
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                                    
                                    switch selectedSection {
                                    case .today:
                                        // Hourly forecast component for 12 hrs
                                        HourlyWeatherView(forecast: forecast)
                                    case .next7Days:
                                        // Daily forecast component for 7 days
                                        DailyWeatherView(forecast: forecast)
                                    }
                                }
                                .padding(.bottom, 100)
                        }
                    
                        // Fetch current location forecast button
                        Button{
                            searchText = ""
                            weatherManager.fetchWeatherforecastForCurrentLocation()
                            locationManager.lookUpCurrentLocation { userLocation in
                                placemarkName = userLocation?.name ?? "..."
                            }
                        }label: {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .frame(width: 52, height: 52)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .background(colorScheme == .dark ? .black : .white)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    .ignoresSafeArea(.keyboard)
                    
                    // Location search bar component
                    LocationSearchBar(isSearchBarVisible: $isSearchBarVisible, searchText: $searchText)
                }
                .navigationBarHidden(true)
            }
            else {
                // Loading view while fetching weather
                LoadingView()
                    .onAppear() {
                        weatherManager.fetchWeatherforecast(forLocation: location)
                    }
            }
        }
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
            .environmentObject(WeatherManager())
            .environmentObject(LocationManager())
    }
}
