//
//  TestView.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 11.08.2024.
//

import Foundation
import SwiftUI

struct TestView: View {
    
    var colors: [Color] = [Color.gray.opacity(0.5), Color.black.opacity(0.5)]
    
    var body: some View {
        ZStack {
            BackgroundViewTest(colors: colors)
            /*
             Group 2xx: Thunderstorm
             200,201,202: thunderstorm with rain -> "thunderstorm_rain"
             
             else thunderstorm -> "thunderstorm"
             [Color]: [Color.blue, Color.gray.opacity(0.7)]
             
             Group 3xx: Drizzle -> "rain"
             Group 5xx: Rain -> "rain"
             [Color.blue, Color.gray.opacity(0.7)]
             
             Group 6xx: Snow -> "snow"
             [Color.gray.opacity(0.5), Color.black.opacity(0.5)]
             
             Group 7xx: Atmosphere -> "cloud"
             [Color.blue, Color.gray.opacity(0.7)]
             
             Group 800: Clear -> "sun"
             [Color.blue, Color.blue.opacity(0.3)]
             
             Group 80x: Clouds
             801 few clouds with sun ->"cloud_sun"
             [Color.blue, Color.blue.opacity(0.3)]
             802, 803, 804 -> "cloud"
             [Color.blue, Color.gray.opacity(0.7)]
             */
        }
    }
}

struct BackgroundViewTest: View {
    var colors: [Color]

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .bottom,
            endPoint: .top
        )
        .ignoresSafeArea()
    }
}
