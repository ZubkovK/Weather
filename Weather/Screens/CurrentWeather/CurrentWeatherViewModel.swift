//
//  CurrentWeatherViewModel.swift
//  Weather
//
//  Created by Кирилл Зубков on 22.03.2024.
//

import Foundation
import UIKit


struct CurrentWeatherViewModel {
    let currentTemperature: Double?
    let currentTempetatureFeelLikes: Double?
    let currentDescription: String?
    let currentCityName: String?
    let currentIconName: String?
    let hourlyForecastModels: [ForecastWeatherDayCellViewModel]
}
