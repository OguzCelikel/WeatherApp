//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Sean Allen on 10/27/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCity: City = cities.first!
    @State private var weatherData: WeatherResponse?
    @State private var error: Error?
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(colors: weatherData == nil ? [Color.blue, Color.blue.opacity(0.3)] : backgroundColors())
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
                            MainWeatherStatusView(imageName: dailyWeather.first?.imageName ?? "sun", temperature: dailyWeather.first?.temperature ?? 0)
                            Spacer()
                            
                            HStack(spacing: 20) {
                                ForEach(dailyWeather, id: \.date) { weather in
                                    WeatherDayView(dayOfWeek: weather.dayOfWeek, imageName: weather.imageName, temperature: weather.temperature)
                                }
                            }
                            
                            NavigationLink(destination: CityListView(cities: cities, selectedCity: $selectedCity)) {
                                WeatherButton(title: "Change The City", textColor: .white, backgroundColor: Color.blue, backgroundOpacity: 1)
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
        
        print("City: \(weatherData.city.name)")
        print("day \(filteredItems.first?.dt_txt ?? "day") -> weatherImage: \(filteredItems.first?.weather.first?.id ?? 200)")
        return filteredItems.map { item in
            let dayOfWeek = dayOfWeek(from: item.dt_txt) ?? "-"
            let tempMaxKelvin = item.main.temp
            let tempMaxCelcius = (tempMaxKelvin - 273.15)
            let weatherImage = determineImageName(for: item.weather.first?.id ?? 200)
            //print("day \(dayOfWeek) -> weatherImage: \(weatherImage)")
            return WeatherDay(date: item.dt_txt, dayOfWeek: dayOfWeek, imageName: weatherImage, temperature: Int(tempMaxCelcius))
        }
    }
    
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
    
    private func determineImageName(for weatherId: Int) -> String {
        let weatherItem = determineWeatherAssets(for: weatherId)
        return (weatherItem.assets.imageName + "2")
    }
    
    private func determineWeatherAssets(for weatherId: Int) -> WeatherType {
        switch weatherId {
        case 200...202:
            return .thunderstormRain
        case 203...232:
            return .thunderstorm
        case 300...321, 500...531:
            return .rain
        case 600...622:
            return .snow
        case 701...781:
            return .atmosphere
        case 800:
            return .clear
        case 801:
            return .cloudSun
        case 802...804:
            return .clouds
        default:
            return .unknown
        }
    }
    
    private func backgroundColors() -> [Color] {
        guard let weatherId = weatherData?.list.first?.weather.first?.id else {
            return [Color.blue, Color.blue.opacity(0.3)]
        }
        let weatherItem = determineWeatherAssets(for: weatherId)
        return weatherItem.assets.colors
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/*
 Group 2xx: Thunderstorm
 200,201,202: thunderstorm with rain -> "thunderstorm_rain"
 else thunderstorm -> "thunderstorm"
 [Color]: [Color.blue, Color.gray.opacity(0.7)]
 
 Group 3xx: Drizzle -> "rain"
 Group 5xx: Rain -> "rain"
 [Color]: [Color.blue, Color.gray.opacity(0.7)]
 
 Group 6xx: Snow -> "snow"
 [Color]: [Color.gray.opacity(0.5), Color.black.opacity(0.5)]
 
 Group 7xx: Atmosphere -> "cloud"
 [Color]: [Color.blue, Color.gray.opacity(0.7)]
 
 Group 800: Clear -> "sun"
 [Color]:
 
 Group 80x: Clouds
 801 few clouds with sun ->"cloud_sun"
 [Color]: [Color.blue, Color.blue.opacity(0.3)]
 802, 803, 804 -> "cloud"
 [Color]: [Color.blue, Color.gray.opacity(0.7)]
 */
