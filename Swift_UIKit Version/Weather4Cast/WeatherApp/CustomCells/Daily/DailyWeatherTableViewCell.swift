//
//  DailyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Avishka Amunugama on 6/4/22.
//

import UIKit
import SDWebImage
import SDWebImageSwiftUI

class DailyWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    
    static let identifier = "DailyWeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 24
        containerView.backgroundColor = .white.withAlphaComponent(0.6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with data:Forecast.Daily) {
        dateLabel.text = configureDate(data.dt)
        tempLabel.text = formatAsString(data.temp.day)
        descLabel.text = data.weather.first?.description.capitalized ?? ""
        humidityLabel.text = "\(data.humidity)%"
        pressureLabel.text = formatAsString(data.pressure) + "hpa"
        windSpeedLabel.text = formatAsString(data.wind_speed) + "km/h"
        weatherImageView.sd_setImage(with: weatherIconURL(from: data.weather.first?.icon), placeholderImage: UIImage(systemName: "hourglass"))
    }
}
