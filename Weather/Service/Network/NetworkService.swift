//
//  NetworkService.swift
//  Weather
//
//  Created by Кирилл Зубков on 19.03.2024.
//

import Foundation
import UIKit

final class NetworkService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
        static let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
        static let iconUrl = "https://openweathermap.org/img/wn/"
        static let appId = "9ce64653675471ba64294e8f9c8f2713"
        
        //    ?lat=59.88&lon=30.36&appid=9ce64653675471ba64294e8f9c8f2713&units=metric&lang=ru
    }
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchCurrentWeather(lat: Double,
                             lon: Double,
                             completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let stringURL = "\(Constants.currentWeatherURL)?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)&units=metric&lang=ru"
        guard let url = URL(string: stringURL) else { return }
        let urlRequest = URLRequest(url: url)
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else if let data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CurrentWeather.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch (let error) {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }.resume()
        }
    }
    
    func fetchIcon(named name: String,
                   completion: @escaping (Result<UIImage, Error>) -> ()) {
        let stringURL = "\(Constants.iconUrl)\(name)@2x.png"
        guard let url = URL(string: stringURL) else { return }
        let urlRequest = URLRequest(url: url)
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else if let data {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            completion(.success(image))
                        } else {
                            completion(.failure(NSError(domain: "Image loading failed", code: 0)))
                        }
                    }
                }
            }.resume()
        }
    }
    
    func fetchFiveDaysWeather(lat: Double,
                              lon: Double,
                              completion: @escaping (Result<FiveDaysWeather, Error>) -> Void) {
        let stringURL = "\(Constants.forecastURL)?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)&units=metric&lang=ru"
        guard let url = URL(string: stringURL) else { return }
        let urlRequest = URLRequest(url: url)
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else if let data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(FiveDaysWeather.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch (let error) {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }.resume()
            
        }
    }
}
