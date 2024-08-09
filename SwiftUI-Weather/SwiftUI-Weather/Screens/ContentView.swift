//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Sean Allen on 10/27/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCity: City = cities.first!
    @Environment(\.colorScheme) var colorScheme
    
    @State private var weatherData: WeatherResponse?
    @State private var error: Error?
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(isDarkMode: colorScheme == .dark)
                
                VStack {
                    if isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else {
                        if let weatherData = weatherData {
                            // Display weather data here
                            let dailyWeather = extractDailyWeather(weatherData: weatherData)
                            
                            CityTextView(cityName: selectedCity.name)
                            
                            MainWeatherStatusView(imageName: dailyWeather.first?.imageName ?? "sun.max.fill", temperature: dailyWeather.first?.temperature ?? 0)
                            //MainWeatherStatusView(imageName: colorScheme == .dark ? "moon.stars.fill" : "cloud.sun.fill", temperature: 76)
                            Spacer()
                            
                            HStack(spacing: 20) {
                                ForEach(dailyWeather, id: \.date) { weather in
                                    WeatherDayView(dayOfWeek: weather.dayOfWeek, imageName: weather.imageName, temperature: weather.temperature)
                                }
                            }
                            
                            NavigationLink(destination: CityListView(cities: cities, selectedCity: $selectedCity)) {
                                WeatherButton(title: "Change The City", textColor: colorScheme == .dark ? .white : .blue, backgroundColor: colorScheme == .dark ? Color.black : Color.white, backgroundOpacity: 1)
                            }
                            
                            
                        } else if let error = error {
                            Text("Error: \(error.localizedDescription)")
                        }
                    }
                    
                    
                    
                    Spacer()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .onAppear() {
                fetchWeather()
            }
        }
    }
    
    
    private func fetchWeather() {
        isLoading = true
        WeatherService().fetchWeather(for: selectedCity) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let data):
                    do {
                        // Decode the data into WeatherResponse
                        let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        self.weatherData = decodedResponse
                        
                    } catch {
                        self.error = error
                        print("Failed to decode JSON: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch weather: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func extractDailyWeather(weatherData: WeatherResponse) -> [WeatherDay] {
        let filteredItems = weatherData.list.filter { $0.dt_txt.contains("12:00:00") }
        
        return filteredItems.map { item in
            let dayOfWeek = dayOfWeek(from: item.dt_txt) ?? "-"
            let imageName = determineImageName(for: item.main.temp) // Function to determine the weather icon
            let tempMaxKelvin = item.main.temp
            let tempMaxCelcius = (tempMaxKelvin - 273.15)
            print(tempMaxCelcius) // Output: 75.8°F
            return WeatherDay(date: item.dt_txt, dayOfWeek: dayOfWeek, imageName: imageName, temperature: Int(tempMaxCelcius))
        }
    }
    
    // Function to get the day of the week from a date string
    private func dayOfWeek(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE" // Full name of the day, e.g., "Fri"
        
        return dayFormatter.string(from: date)
    }
    
    private func determineImageName(for temperature: Double) -> String {
        // Placeholder logic for determining the image name based on temperature
        // Replace this with your actual logic for weather icons
        if temperature < 0 {
            return "snow"
        } else if temperature < 10 {
            return "wind.snow"
        } else if temperature < 20 {
            return "cloud.sun.fill"
        } else if temperature < 30 {
            return "sun.max.fill"
        } else {
            return "sunset.fill"
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

struct WeatherDay {
    let date: String
    let dayOfWeek: String
    let imageName: String
    let temperature: Int
}
