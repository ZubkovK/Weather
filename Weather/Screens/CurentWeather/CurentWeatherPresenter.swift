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
    
    private var currentWeather: CurrentWeather?
    
}

extension CurrentWeatherPresenter: ICurrentWeatherPresenter {
    
    // MARK: - ICurrentWeatherPresenter
    
    func viewDidLoad() {
        let location = LocationService.shared.getLocation()
        
        guard let location else { return }
        NetworkService.shared.fetchCurrentWeather(lat: location.lat,
                                                  lon: location.lon) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.currentWeather = weather
                self?.getIconAndUpdateView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getIconAndUpdateView() {
        guard let currentWeather else { return }
        
        if let icon = currentWeather.weather?.first?.icon {
            NetworkService.shared.fetchIcon(named: icon) { [weak self] result in
                switch result {
                case .success(let image):
                    let viewModel = CurrentWeatherViewModel(
                        temperature: currentWeather.main?.temp,
                        tempetatureFeelLikes: currentWeather.main?.feels_like,
                        description: currentWeather.weather?.first?.description,
                        cityName: currentWeather.name,
                        icon: image
                    )
                    self?.view?.display(model: viewModel)
                case .failure(let error):
                    break
                }
            }
        } else {
            let viewModel = CurrentWeatherViewModel(
                temperature: currentWeather.main?.temp,
                tempetatureFeelLikes: currentWeather.main?.feels_like,
                description: currentWeather.weather?.first?.description,
                cityName: currentWeather.name,
                icon: nil
            )
            self.view?.display(model: viewModel)
        }
    }
    
}
