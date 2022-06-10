//
//  ViewController.swift
//  WeatherApp
//
//  Created by Avishka Amunugama on 6/4/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var currentWeatherView: CurrentWeatherView!
    
    @IBOutlet weak var forecastSegmentControl: UISegmentedControl!
    
    var currentForecast: Forecast.Current?
    var dailyForecasts = [Forecast.Daily]()
    var hourlyForecasts = [Forecast.Current]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        collectionView.register(HourlyWeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLocation()
    }
    
    
    @IBAction func changeForecastView(_ sender: Any) {
        switch forecastSegmentControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = true
            collectionView.isHidden = false
        case 1:
            tableView.isHidden = false
            collectionView.isHidden = true
        default:
            break
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else { return }
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,alerts&appid=660a3e0055a0ebd3e388024dd52d9a6a&units=metric"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                print("Invalid URL. \(error!.localizedDescription)")
                return
            }
            
            // Comvert to model
            
            var result: Forecast?
            
            do {
                result = try JSONDecoder().decode(Forecast.self, from: data)
            }
            catch {
                print("Error: \(error.localizedDescription)")
            }
            
            guard let result = result else { return }
            
            self.dailyForecasts = result.daily
            self.currentForecast = result.current
            self.hourlyForecasts = result.hourly
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
                
                // Configure current weather
                if let current = self.currentForecast, self.currentWeatherView != nil {
                    self.currentWeatherView.configureView(with: current)
                }
            }
            
            //Update the UI
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
        cell.configureCell(with: dailyForecasts[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        cell.configureCell(with: hourlyForecasts[indexPath.row])
        return cell
    }
}

