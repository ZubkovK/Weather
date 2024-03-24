//
//  ForecastWeatherDayCell.swift
//  Weather
//
//  Created by Кирилл Зубков on 23.03.2024.
//

import Foundation
import UIKit

struct ForecastWeatherDayCellViewModel {
    let date: Int
    let tempetature: Double
    let icon: String?
}

final class ForecastWeatherDayCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let dateFont: UIFont = UIFont.systemFont(ofSize: 20)
        static let temperatureFont: UIFont = UIFont.systemFont(ofSize: 34)
        static let iconSize: CGFloat = 80
        static let smallOffset: CGFloat = 8
        static let mediumOffset: CGFloat = 10
        static let dateLeadingOffset: CGFloat = 20
    }
    
    
    // MARK: - Views
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.dateFont
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.temperatureFont
        return label
    }()
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addViews()
        addConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Interface
    
    func display(viewModel: ForecastWeatherDayCellViewModel ) {
        if let iconName = viewModel.icon {
            iconImageView.showIcon(name: iconName)
        } else {
            iconImageView.image = nil
        }
        temperatureLabel.text = "\(String(format: "%.0f", viewModel.tempetature))°"
        
        let date = Date(timeIntervalSince1970: Double(viewModel.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM HH:mm"
        formatter.locale = Locale(identifier: "ru_Ru")
        dateLabel.text = formatter.string(from: date)
    }
    
    
    // MARK: - Private Methods
    
    private func addViews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImageView)
    }
    
    private func addConstaints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.dateLeadingOffset)
            .isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor,
                                                  constant: Constants.mediumOffset).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        iconImageView.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.mediumOffset).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.mediumOffset).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.smallOffset).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    }
    
}
