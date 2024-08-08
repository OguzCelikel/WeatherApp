//
//  CityModel.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 8.08.2024.
//

import SwiftUI

struct City {
    var name: String
    var latitude: Double
    var longitude: Double
    var iconName: String
}

let cities = [
    City(name: "New York", latitude: 40.7128, longitude: -74.0060, iconName: "🗽"), // Statue of Liberty
    City(name: "London", latitude: 51.5074, longitude: -0.1278, iconName: "🇬🇧"), // UK Flag
    City(name: "Paris", latitude: 48.8566, longitude: 2.3522, iconName: "🗼"), // Eiffel Tower
    City(name: "Tokyo", latitude: 35.6762, longitude: 139.6503, iconName: "🗾"), // Map of Japan
    City(name: "Sydney", latitude: -33.8688, longitude: 151.2093, iconName: "🌉"), // Sydney Harbour Bridge
    City(name: "Berlin", latitude: 52.5200, longitude: 13.4050, iconName: "🏛️"), // Classical Building
    City(name: "Rome", latitude: 41.9028, longitude: 12.4964, iconName: "🏛️"), // Classical Building
    City(name: "Beijing", latitude: 39.9042, longitude: 116.4074, iconName: "🏯"), // Japanese Castle
    City(name: "Moscow", latitude: 55.7558, longitude: 37.6173, iconName: "🏰"), // Castle
    City(name: "Rio de Janeiro", latitude: -22.9068, longitude: -43.1729, iconName: "🌴") // Palm Tree
]

