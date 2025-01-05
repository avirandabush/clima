//
//  WeatherData.swift
//  Clima
//
//  Created by Aviran Dabush on 05/01/2025.
//  Copyright © 2025 AD. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main : Decodable {
    let temp: Double
}

struct Weather : Decodable {
    let description: String
    let id: Int
}
