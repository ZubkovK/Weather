//
//  CurrentWeatherPresenter.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import Foundation

protocol ICurrentWeatherPresenter {
    func viewDidLoad()
}

class CurrentWeatherPresenter {
    
    // MARK: - Propertie
    
    weak var view: ICurentWeather?
    private let locationService: LocationService
    
    private var currentWeather: CurrentWeather?
    private var hoursForecastWeather: FiveDaysWeather?
    
    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
        locationService.delegate = self
    }
    
}

extension CurrentWeatherPresenter: ICurrentWeatherPresenter {
    
    // MARK: - ICurrentWeatherPresenter
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        
        if locationService.getWasAuthorizationDetermind() {
            applyNewLocation()
        }
    }
    
    private func applyNewLocation() {
        let location = locationService.getLocation()
        
        let fetchType: WeatherFetchType
        if let location {
            fetchType = .coord(lat: location.lat,
                               lon: location.lon)
        } else {
            fetchType = .cityName("Москва")
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async {
            NetworkService.shared.fetchCurrentWeather(type: fetchType) { [weak self] result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let weather):
                        self?.currentWeather = weather
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async {
            NetworkService.shared.fetchFiveDaysWeather(type: fetchType) { [weak self] result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case.success(let weather):
                        self?.hoursForecastWeather = weather
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.updateView()
            self?.view?.hideActivityIndicator()
        }
    }
    
    private func updateView() {
        guard let currentWeather else { return }
        guard let weatherList = hoursForecastWeather?.list else { return }
        
        let hourlyForecastModels = weatherList.compactMap { item -> ForecastWeatherDayCellViewModel? in
            guard let date = item.dt else { return nil }
            guard let temp = item.main?.temp else { return nil }
            return ForecastWeatherDayCellViewModel(date: date,
                                                   tempetature: temp,
                                                   icon: item.weather?.first?.icon)
        }
        
        let viewModel = CurrentWeatherViewModel(
            currentTemperature: currentWeather.main?.temp,
            currentTempetatureFeelLikes: currentWeather.main?.feels_like,
            currentDescription: currentWeather.weather?.first?.description,
            currentCityName: currentWeather.name,
            currentIconName: currentWeather.weather?.first?.icon,
            hourlyForecastModels: hourlyForecastModels
        )
        view?.display(model: viewModel)
    }
    
}

extension CurrentWeatherPresenter: LocationServiceDelegate {
    
    // MARK: - LocationServiceDelegate
    
    func didUpdateLocation() {
        applyNewLocation()
    }
    
}
