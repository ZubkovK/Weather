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
    func showActivityIndicator()
    func hideActivityIndicator()
}


final class CurrentWeatherViewContoller: UIViewController {
    
    // MARK: - Properies
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
        
    }()
    
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
        label.textColor = .white
        return label
    }()
    
    private let temperatureFeelLikesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private var currentWeatherContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 56/255,
                                       green: 203/255,
                                       blue: 252/255,
                                       alpha: 1)
        return view
    }()
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var fiveDaysTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastWeatherDayCell.self,
                           forCellReuseIdentifier: "ForecastWeatherDayCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let presenter: ICurrentWeatherPresenter
    private var tableViewViewModels = [ForecastWeatherDayCellViewModel]()
   
    
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
        
        addViews()
        addConstrains()
        presenter.viewDidLoad()
    }
    
    
    //MARK: - Private Methods
    
    private func addViews() {
        view.addSubview(currentWeatherContainerView)
        view.addSubview(fiveDaysTableView)
        
        currentWeatherContainerView.addSubview(temperatureLabel)
        currentWeatherContainerView.addSubview(cityNameLabel)
        currentWeatherContainerView.addSubview(weatherStateLabel)
        currentWeatherContainerView.addSubview(temperatureFeelLikesLabel)
        currentWeatherContainerView.addSubview(iconImageView)
        currentWeatherContainerView.addSubview(activityIndicator)
    }
    
    private func addConstrains() {
        currentWeatherContainerView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentWeatherContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currentWeatherContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        currentWeatherContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor,
                                                            constant: -40).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints =  false
        activityIndicator.centerYAnchor.constraint(equalTo: currentWeatherContainerView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor,
                                                  constant: -30 ).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: currentWeatherContainerView.centerYAnchor).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
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
        
        fiveDaysTableView.translatesAutoresizingMaskIntoConstraints = false
        fiveDaysTableView.topAnchor.constraint(equalTo: currentWeatherContainerView.bottomAnchor).isActive = true
        fiveDaysTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        fiveDaysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fiveDaysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension CurrentWeatherViewContoller: ICurentWeather {
    
    // MARK: - ICurentWeather
    
    func display(model: CurrentWeatherViewModel) {
        if let temperature = model.currentTemperature {
            temperatureLabel.text = "\(String(format: "%.0f", temperature))°"
        }
        
        if let feelsLike = model.currentTempetatureFeelLikes {
            temperatureFeelLikesLabel.text = "Ощущается как \(String(format: "%.0f", feelsLike))°"
        }
        
        weatherStateLabel.text = model.currentDescription
        cityNameLabel.text = model.currentCityName
        
        if let iconName = model.currentIconName {
            iconImageView.showIcon(name: iconName)
        } else {
            iconImageView.image = nil
        }
        
        tableViewViewModels = model.hourlyForecastModels
        fiveDaysTableView.reloadData()
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
}

extension CurrentWeatherViewContoller: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastWeatherDayCell")
                as? ForecastWeatherDayCell else { return UITableViewCell() }
        if tableViewViewModels.count > indexPath.row {
            let viewModel = tableViewViewModels[indexPath.row]
            cell.display(viewModel: viewModel)
        }
        return cell
    }
    
    
}

extension CurrentWeatherViewContoller: UITableViewDelegate {
    
}

