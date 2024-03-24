//
//  NetworkService.swift
//  Weather
//
//  Created by Кирилл Зубков on 19.03.2024.
//

import Foundation
import UIKit

enum WeatherFetchType {
    case coord(lat: Double, lon: Double)
    case cityName(String)
}

final class NetworkService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
        static let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
        static let iconUrl = "https://openweathermap.org/img/wn/"
        static let appId = "9ce64653675471ba64294e8f9c8f2713"
    }
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchCurrentWeather(type: WeatherFetchType,
                             completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let queryString: String
        switch type {
        case .cityName(let cityName):
            queryString = "q=\(cityName)"
        case .coord(let lat, let lon):
            queryString = "lat=\(lat)&lon=\(lon)"
        }
        
        let stringURL = "\(Constants.currentWeatherURL)?\(queryString)&appid=\(Constants.appId)&units=metric&lang=ru"
        guard let url = URL(string: stringURL) else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CurrentWeather.self, from: data)
                    completion(.success(result))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchFiveDaysWeather(type: WeatherFetchType,
                              completion: @escaping (Result<FiveDaysWeather, Error>) -> Void) {
        let queryString: String
        switch type {
        case .cityName(let cityName):
            queryString = "q=\(cityName)"
        case .coord(let lat, let lon):
            queryString = "lat=\(lat)&lon=\(lon)"
        }
        
        let stringURL = "\(Constants.forecastURL)?\(queryString)&appid=\(Constants.appId)&units=metric&lang=ru"
        guard let url = URL(string: stringURL) else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FiveDaysWeather.self, from: data)
                    completion(.success(result))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchIcon(named name: String,
                   completion: @escaping (Result<UIImage, Error>) -> ()) {
        let stringURL = "\(Constants.iconUrl)\(name)@2x.png"
        guard let url = URL(string: stringURL) else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data {
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "Image loading failed", code: 0)))
                }
            }
        }.resume()
    }
    
}
