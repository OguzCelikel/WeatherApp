//
//  WeatherResponse.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 5.08.2024.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let list: [WeatherItem]
}

// MARK: - WeatherItem
struct WeatherItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
}
