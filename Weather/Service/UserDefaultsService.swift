//
//  UserDefaultsService.swift
//  Weather
//
//  Created by Кирилл Зубков on 24.03.2024.
//

import Foundation

final class UserDefaultsService {
    
    // MARK: - Key
    
    private enum Key {
        static let currentWeather = "CurrentWeather"
        static let forecastWeather = "ForecastWeather"
        static let currentCity = "CurrentCity"
    }
    
    
    // MARK: - Properties
    
    static let shared = UserDefaultsService()
    
    
    // MARK: - Init
    
    private init() {}
    
    
    // MARK: - Interface
    
    func saveCurrentWeather(_ weather: CurrentWeather) {
        let data = try? JSONEncoder().encode(weather)
        UserDefaults.standard.setValue(data, forKey: Key.currentWeather)
    }
    
    func saveDailyForecast(_ forecast: FiveDaysWeather) {
        let data = try? JSONEncoder().encode(forecast)
        UserDefaults.standard.setValue(data, forKey: Key.forecastWeather)
    }
    
    func saveCurrentCityName(_ name: String) {
        UserDefaults.standard.setValue(name, forKey: Key.currentCity)
    }
    
    func getCurrentWeather() -> CurrentWeather? {
        guard let data = UserDefaults.standard.object(forKey: Key.currentWeather) as? Data else { return nil }
        return try? JSONDecoder().decode(CurrentWeather.self, from: data)
    }
    
    func getDailyForecast() -> FiveDaysWeather? {
        guard let data = UserDefaults.standard.object(forKey: Key.forecastWeather) as? Data else { return nil }
        return try? JSONDecoder().decode(FiveDaysWeather.self, from: data)
    }
    
    func getCurrentCityName() -> String? {
        return UserDefaults.standard.string(forKey: Key.currentCity)
    }
    
}
