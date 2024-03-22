//
//  CurentWeather.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import Foundation
import UIKit

protocol ICurentWeather: AnyObject {
    func display(model: CurrentWeatherViewModel)
}


final class CurrentWeatherViewContoller: UIViewController {
    
    // MARK: - Properies
    
    private let presenter: ICurrentWeatherPresenter
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 68)
        label.textColor = .white
        return label
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private let weatherStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.alpha = 0.9
        label.textColor = .white
        return label
    }()
    
    private let temperatureFeelLikesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        label.alpha = 0.9
        return label
    }()
    
    private var currentWeatherContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 18/255,
                                       green: 89/255,
                                       blue: 140/255,
                                       alpha: 1)
        return view
    }()
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    // MARK: - Init
    
    init(presenter: ICurrentWeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        addViews()
        addConstrains()
        presenter.viewDidLoad()
    }
    
    
    //MARK: - Private Methods
    
    private func addViews() {
        view.addSubview(currentWeatherContainerView)
        
        currentWeatherContainerView.addSubview(temperatureLabel)
        currentWeatherContainerView.addSubview(cityNameLabel)
        currentWeatherContainerView.addSubview(weatherStateLabel)
        currentWeatherContainerView.addSubview(temperatureFeelLikesLabel)
        currentWeatherContainerView.addSubview(iconImageView)
    }
    
    private func addConstrains() {
        currentWeatherContainerView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentWeatherContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currentWeatherContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        currentWeatherContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor,
                                                            constant: -60).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: currentWeatherContainerView.centerYAnchor).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 8).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 76).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor).isActive = true
        cityNameLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -16).isActive = true
        
        weatherStateLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherStateLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8).isActive = true
        weatherStateLabel.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor).isActive = true
        
        temperatureFeelLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureFeelLikesLabel.topAnchor.constraint(equalTo: weatherStateLabel.bottomAnchor, 
                                                       constant: 8).isActive = true
        temperatureFeelLikesLabel.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor).isActive = true
    }
}

extension CurrentWeatherViewContoller: ICurentWeather {
    
    // MARK: - ICurentWeather
    
    func display(model: CurrentWeatherViewModel) {
        if let temperature = model.temperature {
            temperatureLabel.text = "\(String(temperature))°"
        }
        
        if let feelsLike = model.tempetatureFeelLikes {
            temperatureFeelLikesLabel.text = "Ощущается как \(String(feelsLike))°"
        }
        
        weatherStateLabel.text = model.description
        cityNameLabel.text = model.cityName
        iconImageView.image = model.icon
    }
    
}
