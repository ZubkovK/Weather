//
//  CurrentWeatherPresenter.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import Foundation

protocol ICurrentWeatherPresenter {
    
    // MARK: - Protocol
    
    func viewDidLoad()
    
}

final class CurrentWeatherPresenter {
    
    // MARK: - Constants
    
    private enum Constants {
        static let defaultCityName = "Москва"
    }
    
    
    // MARK: - Properties
    
    weak var view: ICurentWeather?
    
    private let locationService: LocationService
    private var currentWeather: CurrentWeather?
    private var hoursForecastWeather: FiveDaysWeather?
    private var currentLocationName: String?
    
    
    // MARK: - Init
    
    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
        locationService.delegate = self
    }
    
    
    // MARK: - Private Methods
    
    private func applyCache() {
           guard let currentWeather = UserDefaultsService.shared.getCurrentWeather() else { return }
           guard let forecastWeather = UserDefaultsService.shared.getDailyForecast() else { return }
           
           self.currentWeather = currentWeather
           hoursForecastWeather = forecastWeather
           
           currentLocationName = UserDefaultsService.shared.getCurrentCityName()
           
           updateView()
           view?.hideActivityIndicator()
       }
       
       private func applyNewLocation() {
           let location = locationService.getLocation()
           let fetchType: WeatherFetchType
           if let location {
               fetchType = .coord(lat: location.coordinate.latitude,
                                  lon: location.coordinate.longitude)
           } else {
               fetchType = .cityName(Constants.defaultCityName)
           }
           
           let dispatchGroup = DispatchGroup()
           
           dispatchGroup.enter()
           DispatchQueue.global().async {
               NetworkService.shared.fetchCurrentWeather(type: fetchType) { [weak self] result in
                   DispatchQueue.main.async { [weak self] in
                       switch result {
                       case .success(let weather):
                           self?.currentWeather = weather
                           UserDefaultsService.shared.saveCurrentWeather(weather)
                       case .failure(let error):
                           print(error.localizedDescription)
                       }
                       dispatchGroup.leave()
                   }
               }
           }
           
           if let location {
               dispatchGroup.enter()
               DispatchQueue.global().async { [weak self] in
                   guard let self else { return }
                   self.locationService.getLocationName(location: location) { result in
                       DispatchQueue.main.async {
                           switch result {
                           case .success(let locationName):
                               self.currentLocationName = locationName
                               UserDefaultsService.shared.saveCurrentCityName(locationName)
                           case .failure(let error):
                               print(error.localizedDescription)
                           }
                           dispatchGroup.leave()
                       }
                   }
               }
           }
           
           dispatchGroup.enter()
           DispatchQueue.global().async {
               NetworkService.shared.fetchFiveDaysWeather(type: fetchType) { [weak self] result in
                   DispatchQueue.main.async { [weak self] in
                       switch result {
                       case.success(let forecast):
                           self?.hoursForecastWeather = forecast
                           UserDefaultsService.shared.saveDailyForecast(forecast)
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
               currentCityName: currentLocationName ?? currentWeather.name,
               currentIconName: currentWeather.weather?.first?.icon,
               hourlyForecastModels: hourlyForecastModels
           )
           view?.display(model: viewModel)
       }
    
}

extension CurrentWeatherPresenter: ICurrentWeatherPresenter {
    
    // MARK: - ICurrentWeatherPresenter
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        
        applyCache()
        
        if locationService.getWasAuthorizationDetermind() {
            applyNewLocation()
        }
    }
    
}

extension CurrentWeatherPresenter: LocationServiceDelegate {
    
    // MARK: - LocationServiceDelegate
    
    func didUpdateLocation() {
        applyNewLocation()
    }
    
}
