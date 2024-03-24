//
//  ModelFiveDays.swift
//  Weather
//
//  Created by Кирилл Зубков on 22.03.2024.
//

import Foundation

struct FiveDaysWeather: Codable {
    let cod: String
    let message: Int?
    let cnt: Int?
    let list: [ForecastWeather]?
    let city: City?
    
}

struct ForecastWeather: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let rain: Rain?
    let snow: Snow?
    let visibility: Int?
    let pop: Double?
    let sys: Sys?
    let dtText: String?
     
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case rain
        case snow
        case visibility
        case pop
        case sys
        case dtText = "dt_txt"
    }
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}


