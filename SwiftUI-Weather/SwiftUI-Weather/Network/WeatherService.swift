//
//  WeatherService.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 8.08.2024.
//

import Foundation

struct WeatherService {
    private let apiKey = ""
    
    func fetchWeather(for city: City, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}

