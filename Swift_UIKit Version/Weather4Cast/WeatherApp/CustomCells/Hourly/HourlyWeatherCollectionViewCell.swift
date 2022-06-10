//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Avishka Amunugama on 6/4/22.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    
    
    static let identifier = "HourlyWeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 24
        containerView.backgroundColor = .white.withAlphaComponent(0.6)
    }
    
    func configureCell(with data:Forecast.Current) {
        timeLabel.text = configureDate(data.dt)
        tempLabel.text = formatAsString(data.temp)
        descLabel.text = data.weather.first?.description.capitalized ?? ""
        weatherImageView.sd_setImage(with: weatherIconURL(from: data.weather.first?.icon), placeholderImage: UIImage(systemName: "hourglass"))
    }

}
