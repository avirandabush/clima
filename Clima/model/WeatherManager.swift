//
//  WeatherManager.swift
//  Clima
//
//  Created by Aviran Dabush on 05/01/2025.
//  Copyright © 2025 AD. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=03b6b21fd94342e5879d5c608c28cfbd&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let combineUrl = "\(url)&q=\(cityName)"
        performRequest(urlString: combineUrl)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let combineUrl = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: combineUrl)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safaData = data {
                    if let weather = self.parseJSON(safaData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather.first?.id ?? 0
            let temp = decodeData.main.temp
            let name = decodeData.name
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
