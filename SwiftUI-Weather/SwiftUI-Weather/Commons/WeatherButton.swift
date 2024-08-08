//
//  WeatherButton.swift
//  SwiftUI-Weather
//
//  Created by Sean Allen on 10/27/20.
//

import SwiftUI

struct WeatherButton: View {
    
    var title: String
    var textColor: Color
    var backgroundColor: Color
    var backgroundOpacity: Double
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor.opacity(backgroundOpacity).gradient)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold))
            .cornerRadius(10)
    }
}

struct WeatherButton_Previews: PreviewProvider {
    static var previews: some View {
        WeatherButton(
            title: "Test Title",
            textColor: .white,
            backgroundColor: .blue,
            backgroundOpacity: 0.5 // Transparanlık oranı burada ayarlanır
        )
    }
}
