//
//  Model.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import Foundation

struct ResultIn: Codable {
    let coord: Сoord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds?
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String?
    let cod: Int
    
    
}

struct Сoord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String?
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int?
    let humidity: Int?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Rain: Codable {
    let h1: Double?
    let h3: Double?
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
        case h3 = "3h"
    }
}

struct Snow: Codable {
    let h1: Double?
    let h3: Double?
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
        case h3 = "3h"
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
