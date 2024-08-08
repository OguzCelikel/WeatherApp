//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Sean Allen on 10/27/20.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCity: City = cities.first!
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(isDarkMode: colorScheme == .dark)
                
                VStack {
                    CityTextView(cityName: selectedCity.name)
                    
                    MainWeatherStatusView(imageName: colorScheme == .dark ? "moon.stars.fill" : "cloud.sun.fill", temperature: 76)
                    Spacer()
                    
                    HStack(spacing: 20) {
                        WeatherDayView(dayOfWeek: "TUE", imageName: "cloud.sun.fill", temperature: 74)
                        WeatherDayView(dayOfWeek: "WED", imageName: "sun.max.fill", temperature: 88)
                        WeatherDayView(dayOfWeek: "THU", imageName: "wind.snow", temperature: 55)
                        WeatherDayView(dayOfWeek: "FRI", imageName: "sunset.fill", temperature: 60)
                        WeatherDayView(dayOfWeek: "SAT", imageName: "snow", temperature: 25)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CityListView(cities: cities, selectedCity: $selectedCity)) {
                        WeatherButton(title: "Change The City", textColor: colorScheme == .dark ? .white : .blue, backgroundColor: colorScheme == .dark ? Color.black : Color.white, backgroundOpacity: 1)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    var isDarkMode: Bool
    
    var body: some View {
        ContainerRelativeShape()
            .fill(isDarkMode ? Color.black.gradient : Color.blue.gradient)
            .ignoresSafeArea()
    }
}

struct CityTextView: View {
    
    var cityName: String
    var body: some View {
        HStack {
            Text(cityName)
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(.white)
                .padding()
        }
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}
