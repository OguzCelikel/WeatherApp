//
//  WeatherEnums.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 10.08.2024.
//

import SwiftUI

enum WeatherType {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
    case unknown

    var assets: (imageName: String, colors: [Color]) {
        switch self {
        case .thunderstorm:
            return ("thunderstorm", [Color.blue, Color.gray.opacity(0.7)])
        case .drizzle, .rain:
            return ("rain", [Color.blue, Color.gray.opacity(0.7)])
        case .snow:
            return ("snow", [Color.gray.opacity(0.5), Color.black.opacity(0.5)])
        case .atmosphere:
            return ("cloud", [Color.blue, Color.gray.opacity(0.7)])
        case .clear:
            return ("sun", [Color.blue, Color.blue.opacity(0.3)])
        case .clouds:
            return ("cloud", [Color.blue, Color.gray.opacity(0.7)])
        case .unknown:
            return ("sun", [Color.blue, Color.blue.opacity(0.3)])
        }
    }
}
