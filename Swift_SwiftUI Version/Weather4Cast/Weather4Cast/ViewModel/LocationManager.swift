//
//  LocationManager.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/22/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    @Published var currentLocation:CLLocationCoordinate2D?
    @Published var isLoading: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // Request user's current location
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    // Check for authorization and prompt user if needed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location services restricted.")
        case .denied:
            print("Location access denied by user.")
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = manager.location?.coordinate
        @unknown default:
            break
        }
    }
    
    // Triggered when user's location is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
        isLoading = false
    }
    
    // Triggered when fail to receive user location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
        isLoading = false
    }
    
    // Obtain the name of user's current location - placemark name
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = manager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    completionHandler(nil)
                }
            })
        }
        else {
            completionHandler(nil)
        }
    }
    
    // Obtains the coordinates of searched locations
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }

            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
