//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Sean Allen on 10/27/20.
//

import SwiftUI
import Lottie

struct ContentView: View {
    
    @State private var selectedCity: City = cities.first!
    @State private var weatherData: WeatherResponse?
    @State private var error: Error?
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
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
                            MainWeatherStatusView(imageName: "sun", temperature: dailyWeather.first?.temperature ?? 0)
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
        
        return filteredItems.map { item in
            let dayOfWeek = dayOfWeek(from: item.dt_txt) ?? "-"
            // imageName = determineImageName(for: item.main.temp) // Function to determine the weather icon
            let tempMaxKelvin = item.main.temp
            let tempMaxCelcius = (tempMaxKelvin - 273.15)
            let weatherImage = determineImageName(for: item.weather.first?.id ?? 200)
            return WeatherDay(date: item.dt_txt, dayOfWeek: dayOfWeek, imageName: weatherImage, temperature: Int(tempMaxCelcius))
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
    
    private func determineImageName(for weatherId: Int) -> String {
        switch weatherId {
        case 200, 201, 202:
            return ("thunderstorm_rain2")
        case 210...232:
            return ("thunderstorm2")
        case 300...321, 500...531:
            //return ("rain2")
            return("sun2")
        case 600...622:
            return ("snow2")
        case 701...781:
            return ("cloud2")
        case 800:
            return ("sun2")
        case 801:
            //return ("cloud_sun2")
            return("sun2")
        case 802...804:
            return ("cloud2")
        default:
            return ("sun2")
        }
    }
    
    private func determineWeatherAssets(for weatherId: Int) -> (String, [Color]) {
            switch weatherId {
            case 200, 201, 202:
                return ("thunderstorm_rain", [Color.blue, Color.gray.opacity(0.7)])
            case 210...232:
                return ("thunderstorm", [Color.blue, Color.gray.opacity(0.7)])
            case 300...321, 500...531:
                return ("rain", [Color.blue, Color.gray.opacity(0.7)])
            case 600...622:
                return ("snow", [Color.gray.opacity(0.5), Color.black.opacity(0.5)])
            case 701...781:
                return ("cloud", [Color.blue, Color.gray.opacity(0.7)])
            case 800:
                return ("sun", [Color.yellow])
            case 801:
                return ("cloud_sun", [Color.blue, Color.blue.opacity(0.3)])
            case 802...804:
                return ("cloud", [Color.blue, Color.gray.opacity(0.7)])
            default:
                return ("sun", [Color.yellow])
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
        VStack(spacing: 10) {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            LottieView(animationFileName: imageName, loopMode: .loop)
                .frame(width: 40, height: 40)
                .padding(6)
                
            
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}


struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: gradientColors()),
            startPoint: .bottom,
            endPoint: .top
        )
        .ignoresSafeArea()
    }
    private func gradientColors() -> [Color] {
        return [Color.blue, Color.blue.opacity(0.3)]
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
            LottieView(animationFileName: imageName, loopMode: .loop)
                .frame(width: 180, height: 180)
                .padding(20)
            
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


struct LottieView: UIViewRepresentable {
    
    var animationFileName: String
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFill
        return animationView
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
