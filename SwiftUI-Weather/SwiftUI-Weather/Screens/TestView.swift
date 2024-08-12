//
//  TestView.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 11.08.2024.
//

import SwiftUI

struct TestView: View {
    var height: CGFloat = 500
    var bgImage = UIImage(named: "cloud1")
    //rain1, cloud1
    var body: some View {
        ZStack {
            if let bgImage = bgImage {
                Image(uiImage: bgImage) // UIImage'ı SwiftUI Image'ına dönüştür
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 50.0, opaque: true)
            }
            
            VStack(spacing: 10) {
                
                Text("Hi, it is a beatiful rainy day")
                    .font(.title2)
                    .bold()
                    .padding()
                
                
                if let bgImage = bgImage {
                    ZStack {
                        Image(uiImage: bgImage)
                            .resizable()
                            .aspectRatio(0.7, contentMode: .fit)
                            .frame(height: height)
                            .cornerRadius(30)
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.5)]),
                            startPoint: .bottomTrailing,
                            endPoint: .topLeading
                        )
                        .frame(height: height)
                        .cornerRadius(30)
                        .mask(Image(uiImage: bgImage)
                            .resizable()
                            .aspectRatio(0.7, contentMode: .fit)
                            .frame(height: height)
                            .cornerRadius(30)
                        ) // Ensure the gradient overlay follows the image's shape
                        
                        VStack {
                            LocationInfoView(location: "Los Angle, UK", time: "now, 08:24")
                            Spacer()
                            WeatherInfoView(weatherIcon: "cloud.rain", temperature: 19)
                            Spacer()
                            
                        }
                    }
                    .frame(height: height) // Ensure the ZStack has the correct frame height
                    .padding(.top)
                }
                Spacer()
                MusicView(imageName: "clearF1", songTitle: "Song Title", artistName: "Artist Name")
                Spacer()
            }
        }
    }
}

struct LocationInfoView: View {
    var location: String
    var time: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(location)
                .font(.title3)
                .bold()
            Text(time)
                .font(.subheadline)
        }
        .padding(10)
    }
}

struct WeatherInfoView: View {
    var weatherIcon: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: weatherIcon)
                .font(.system(size: 100, weight: .regular))
            VStack {
                Text("\(temperature)°")
                    .font(.system(size: 56, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

struct MusicView: View {
    var imageName: String
    var songTitle: String
    var artistName: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            
            
            VStack(alignment: .leading) {
                Text(songTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

        }
        .padding()
        
        .background(Color.black.opacity(0.3)) // Opacity verilmiş arka plan
        .cornerRadius(12) // Köşeleri yuvarlatılmış
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


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

/*
 enum ClothingItem: String {
 case tShirt = "tshirt"
 case jacket = "jacket"
 case umbrella = "umbrella"
 case sweater = "sweater"
 case hat = "hat"
 case scarf = "scarf"
 case shorts = "shorts"
 case gloves = "gloves"
 case coat = "coat"
 }
 
 struct OutfitView: View {
 let clothingItems: [ClothingItem]
 
 var body: some View {
 HStack {
 ForEach(clothingItems, id: \.self) { item in
 Image(item.rawValue)
 .resizable()
 .scaledToFit()
 .frame(width: 50, height: 50)
 .padding()
 }
 }
 }
 }
 
 func outfitRecommendation(temperature: Double, humidity: Double, windSpeed: Double) -> [ClothingItem] {
 // Combined Recommendations
 switch (temperature, humidity, windSpeed) {
 case (let temp, let hum, _) where temp > 30 && hum > 80:
 return [.tShirt, .shorts, .hat]
 
 case (let temp, _, let wind) where temp > 30 && wind > 30:
 return [.tShirt, .shorts, .hat]
 
 case (20...30, let hum, let wind) where hum > 80 && wind > 30:
 return [.tShirt, .jacket, .hat]
 
 case (20...30, _, let wind) where wind > 30:
 return [.tShirt, .jacket, .scarf]
 
 case (10...20, let hum, let wind) where hum > 80 && wind > 30:
 return [.sweater, .jacket, .umbrella]
 
 case (10...20, _, let wind) where wind > 30:
 return [.sweater, .jacket, .scarf]
 
 case (let temp, _, let wind) where temp < 20 && wind < 15:
 return [.sweater, .jacket, .gloves]
 
 case (let temp, _, let wind) where temp < 10 && wind > 15:
 return [.coat, .gloves, .scarf, .hat]
 
 case (let temp, let hum, _) where temp < 10 && hum > 80:
 return [.coat, .gloves, .umbrella]
 
 default:
 return [.tShirt, .jacket]
 }
 }
 
 */
