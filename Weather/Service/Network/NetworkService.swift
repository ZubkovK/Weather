//
//  NetworkService.swift
//  Weather
//
//  Created by Кирилл Зубков on 19.03.2024.
//

import Foundation

class NetworkService {
    
    static let sharedi = NetworkService()
    
    private init() {}
    
    func fetchData() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=59.88&lon=30.36&appid=9ce64653675471ba64294e8f9c8f2713&units=metric&lang=ru") else { return }
        var urlRequest = URLRequest(url: url)
        DispatchQueue.global().async {
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ResultIn.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } catch (let error) {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
            
        }
        
    }
}
