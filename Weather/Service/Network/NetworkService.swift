//
//  NetworkService.swift
//  Weather
//
//  Created by Кирилл Зубков on 19.03.2024.
//

import Foundation

final class NetworkService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
        static let appId = "9ce64653675471ba64294e8f9c8f2713"
    }
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchCurrentWeather(lat: Double, 
                             lon: Double,
                             completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let stringURL = "\(Constants.baseUrl)?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)&units=metric&lang=ru"
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
}
