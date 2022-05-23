//
//  WeatherManager.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import SwiftUI
import CoreLocation

class WeatherManager: ObservableObject {
        
    @Published var forecast: ForecastViewModel?
    @Published var locationManager = LocationManager()
    @Published var isLoading: Bool = true
    var lastLocation: String = ""
    @Published var inCelcius: Bool = true
    @Published var appError: AppError? = nil
    @Published var isValidSearch: Bool = false
    
    // Switch celcius and fahrenheit
    func toggleUnits() {
        inCelcius = !inCelcius
        
        if let forecast = forecast {
            forecast.inCelcius = !forecast.inCelcius
        }
    }
    
    // Fetch weather forecast for user's current location
    func fetchWeatherforecastForCurrentLocation() {
        locationManager.requestLocation()
        
        if let location = locationManager.currentLocation {
            fetchWeatherforecast(forLocation: location)
        }
    }

    // Fetch weather forecast for search text
    func fetchWeatherforecast(forText searchText:String) {
        var searchedLocation: CLLocationCoordinate2D?
        
        if !(searchText.isEmpty) {
            
            // Removes numbers from search text and lowercases
            let cleanedText = searchText.components(separatedBy: CharacterSet.decimalDigits).joined().lowercased()
            
            locationManager.getCoordinate(addressString: cleanedText) { locationCoordinate, error in
                
                if let error = error as? CLError{
                    
                    self.isValidSearch = false
                    
                    switch error.code {
                    case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                        self.appError = AppError(errorString: NSLocalizedString("Unable to determine the location for the text.", comment: ""))
                    case .network:
                        self.appError = AppError(errorString: NSLocalizedString("You do not appear to have a stable internet connection.", comment: ""))
                    default:
                        self.appError = AppError(errorString: error.localizedDescription)
                    }
        
                    print(error.localizedDescription)
                } else {
                    self.isValidSearch = true
                    searchedLocation = locationCoordinate
                    print("\(searchedLocation!)")
                    self.fetchWeatherforecast(forLocation: searchedLocation!)
                }
            }
        }
    }
    
    // Fetch weather forecast from location coordinates
    func fetchWeatherforecast(forLocation location: CLLocationCoordinate2D) {
        
        let apiService = APIService.shared
        
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.latitude)&lon=\(location.longitude)&exclude=minutely,alerts&appid=660a3e0055a0ebd3e388024dd52d9a6a&units=metric"
        
        apiService.getJSON(urlString: urlString, dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast, APIService.APIError>) in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.forecast = ForecastViewModel(currentForecast: forecast.current, hourlyForecast: forecast.hourly, dailyForecast: forecast.daily, inCelcius: self.inCelcius)
                }
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    DispatchQueue.main.async {
                    self.isLoading = false
                    self.appError = AppError(errorString: errorString)
                    print(errorString)
                    }
                }
            }
        }
    }
}
