//
//  CurentWeather.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import Foundation
import UIKit

protocol ICurentWeather: AnyObject {
    func display(model: CurentWeatherViewModel)
}


// Current
final class CurentWeatherViewContoller: UIViewController {
    
    // MARK: - Properies
    
    private let presenter: ICurentWeatherPresenter
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.text = "2"
        return temperatureLabel
    }()
    private let cityNameLabel: UILabel = {
        let cityName = UILabel()
        cityName.text = "cityName"
        return cityName
    }()
    private let weatherStateLabel: UILabel = {
        let weatherState = UILabel()
        weatherState.text = "облачно"
        return weatherState
    }()
    private let temperatureFeelLikesLabel: UILabel = {
        let temperature = UILabel()
        temperature.text = "Ощущается как 0"
        return temperature
    }()
    
    
    // MARK: - Init
    
    init(presenter: ICurentWeatherPresenter) {
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
        view.addSubview(temperatureLabel)
        view.addSubview(cityNameLabel)
        view.addSubview(weatherStateLabel)
        view.addSubview(temperatureFeelLikesLabel)
    }
    
    private func addConstrains() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityNameLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -8).isActive = true
        
        weatherStateLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherStateLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8).isActive = true
        weatherStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        temperatureFeelLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureFeelLikesLabel.topAnchor.constraint(equalTo: weatherStateLabel.bottomAnchor, constant: 8).isActive = true
        temperatureFeelLikesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true 
        
        
        
        
        
        
    }
}

extension CurentWeatherViewContoller: ICurentWeather {
    func display(model: CurentWeatherViewModel) {
        if let temperature = model.temperature {
            temperatureLabel.text = String(temperature)
        }
        
        temperatureLabel.text = "\(String(describing: model.temperature))"
        temperatureFeelLikesLabel.text = "\(String(describing: model.tempetatureFeelLikes))"
        weatherStateLabel.text = model.description
        cityNameLabel.text = model.cityName
        
    }
}
