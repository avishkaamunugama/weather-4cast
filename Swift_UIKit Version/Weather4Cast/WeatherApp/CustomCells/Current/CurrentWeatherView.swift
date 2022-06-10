//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Avishka Amunugama on 6/5/22.
//

import UIKit

class CurrentWeatherView: UIView {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var primaryView: UIView!
    @IBOutlet var secondaryView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        let currentView = Bundle.main.loadNibNamed("CurrentWeatherView", owner: self, options: nil)![0] as! UIView
        currentView.frame = self.bounds
        addSubview(currentView)
        
        primaryView.layer.cornerRadius = 24
        primaryView.backgroundColor = .white.withAlphaComponent(0.6)
        secondaryView.layer.cornerRadius = 24
        secondaryView.backgroundColor = .white.withAlphaComponent(0.6)
    }
    
    func configureView(with current: Forecast.Current) {
        
        dateLabel.text = configureDate(current.dt)
        tempLabel.text = formatAsString(current.temp)
        descLabel.text = current.weather.first?.description.capitalized ?? ""
        humidityLabel.text = "\(current.humidity)%"
        pressureLabel.text = formatAsString(current.pressure) + "hpa"
        windSpeedLabel.text = formatAsString(current.wind_speed) + "km/h"
        weatherImageView.sd_setImage(with: weatherIconURL(from: current.weather.first?.icon), placeholderImage: UIImage(systemName: "hourglass"))
    }
    
    
}
