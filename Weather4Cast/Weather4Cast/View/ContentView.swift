//
//  ContentView.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import SwiftUI
import CoreLocationUI

struct ContentView: View {
    
    @StateObject var weatherManager = WeatherManager()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        
        // Show welcome view if current location not yet identified
        if locationManager.currentLocation != nil {
            WeatherForecastView()
                .environmentObject(weatherManager)
                .environmentObject(locationManager)
                .alert(item: $weatherManager.appError) { appAlert in
                    Alert(title: Text("Error"),
                          message: Text("""
                                \(appAlert.errorString)
                                Please try again later!
                                """
                                       )
                    )
                }
        }
        else {
            WelcomeView()
                .environmentObject(locationManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        
    }
}
